class RequestsController < ApplicationController
  before_action :require_login

  def new
    @request = Request.new
    @characters = Character.all.order(:name)
  end

  def create
    @request = current_user.requests.build(request_params)

    if @request.save
      create_character_associations
      send_request_created_notification(@request) # 通知送信を追加
      redirect_to posts_path, notice: t('defaults.flash_message.created', item: Request.model_name.human)
    else
      @characters = Character.all.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  private

  def request_params
    params.require(:request).permit(:message)
  end

  def create_character_associations
    return unless params[:character_ids].present?

    params[:character_ids].each do |character_id|
      next if character_id.blank?
      @request.request_to_characters.create!(character_id: character_id)
    end
  end

  # 新しいリクエスト作成通知を送信
  def send_request_created_notification(request)
    # 通知を受け取る設定をしているユーザーを取得
    notification_recipients = User.receives_request_notifications

    # キャラクター情報を取得
    character_names = request.characters.pluck(:name)
    character_ids = request.characters.pluck(:id)

    # 通知を送信（最新のnoticed）
    RequestCreatedNotifier.with(
      record: request,                    # これはrecordとして渡される
      character_names: character_names,
      character_ids: character_ids,
    ).deliver(notification_recipients)
  end
end
