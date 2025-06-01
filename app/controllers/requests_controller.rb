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
      notify_users_about_request(@request)
      redirect_to posts_path, notice: 'リクエストが正常に送信されました。'
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

  def notify_users_about_request(request)
  end
end
