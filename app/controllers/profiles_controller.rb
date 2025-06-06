class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(user_params)
      # アバターが更新された時に圧縮する
      compress_avatar if params[:user][:avatar].present?
      redirect_to profile_path, success: t('defaults.flash_message.updated', item: User.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :user_name, :avatar, :receive_request_notifications)
  end

  # アバター画像の圧縮処理
  def compress_avatar
    return unless @user.avatar.attached?

    # 元の画像情報を取得
    original_blob = @user.avatar.blob
    original_attachment = @user.avatar.attachment

    begin
      # バリアント生成（WebP形式に変換）
      variant = @user.avatar.variant(
        resize_to_fill: [150, 150], # アバター用のサイズ
        format: :webp,               # WebP形式に変換
        saver: {
          quality: 85,               # 85%品質
          strip: true                # メタデータ削除
        }
      ).processed

      # 処理済み画像をダウンロード
      processed_image = variant.download

      # 新しい画像を先に添付（重要: 元画像を削除する前に行う）
      new_filename = "avatar_#{@user.id}_#{Time.current.to_i}.webp"
      new_blob = ActiveStorage::Blob.create_and_upload!(
        io: StringIO.new(processed_image),
        filename: new_filename,
        content_type: 'image/webp'
      )

      # 新しい添付を作成
      new_attachment = ActiveStorage::Attachment.create!(
        name: 'avatar',
        record_type: 'User',
        record_id: @user.id,
        blob_id: new_blob.id
      )

      # 元の添付を削除
      original_attachment.destroy if original_attachment.id != new_attachment.id

      # 元のBlobを削除（不要になったストレージ領域を解放）
      if original_blob.present? && original_blob.id != new_blob.id
        ActiveRecord::Base.transaction do
          # Blobに紐づく他のAttachmentがないことを確認
          remaining_attachments = ActiveStorage::Attachment.where(blob_id: original_blob.id).count
          original_blob.purge if remaining_attachments == 0
        end
      end

      # Userモデルのタイムスタンプを更新（キャッシュ対策）
      @user.touch
    rescue StandardError => e
      Rails.logger.error "アバター圧縮エラー: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
