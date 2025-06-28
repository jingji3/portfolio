module Admin
  class CharactersController < Admin::ApplicationController
    def create
      resource = resource_class.new(resource_params)

      if resource.save
        # 保存成功後に圧縮実行
        compress_character_image(resource) if resource.character_img.attached?
        redirect_to([ namespace, resource ], notice: "登録しました")
      else
        render :new, locals: { page: Administrate::Page::Form.new(dashboard, resource) }
      end
    end

    def update
      if requested_resource.update(resource_params)
        # 更新成功後に圧縮実行
        compress_character_image(requested_resource) if resource_params[:character_img].present?
        redirect_to([ namespace, requested_resource ], notice: "更新しました")
      else
        render :edit, locals: { page: Administrate::Page::Form.new(dashboard, requested_resource) }
      end
    end

    private

    # 画像圧縮メソッド
    def compress_character_image(character)
      return unless character.character_img.attached?

      # 元の画像情報を取得
      original_blob = character.character_img.blob
      original_attachment = character.character_img.attachment

      begin
        # バリアント生成（WebP形式に変換）
        variant = character.character_img.variant(
          resize_to_limit: [ 700, 800 ],  # 元サイズを維持しつつ最大サイズを制限
          format: :webp,                # WebP形式で高圧縮率
          saver: {
            quality: 85,                # 画質85%（十分高品質）
            strip: true                 # メタデータ削除
          }
        ).processed

        # 処理済み画像をダウンロード
        processed_image = variant.download

        # 新しい画像を先に添付（重要: 元画像を削除する前に行う）
        new_filename = "character_#{character.id}_#{Time.current.to_i}.webp"
        new_blob = ActiveStorage::Blob.create_and_upload!(
          io: StringIO.new(processed_image),
          filename: new_filename,
          content_type: "image/webp"
        )

        # 新しい添付を作成
        new_attachment = ActiveStorage::Attachment.create!(
          name: "character_img",
          record_type: "Character",
          record_id: character.id,
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

        # キャラクターモデルのタイムスタンプを更新（キャッシュ対策）
        character.touch
      rescue StandardError => e
        Rails.logger.error "#{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end
end
