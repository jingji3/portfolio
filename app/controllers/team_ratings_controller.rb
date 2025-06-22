class TeamRatingsController < ApplicationController
  include CharacterSelect #concernsのキャラクター選択用メソッド

  before_action :require_login
  before_action :set_team_rating, only: %i[edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]
  before_action :set_characters_data, only: %i[new create] #キャラクターデータをセット

  def new
    @team_rating = TeamRating.new

    # team_idが渡された場合、そのチームのキャラクターIDを取得,評価していない編成を評価する時のため
    if params[:team_id].present?
      @team = Team.find(params[:team_id])
      @selected_character_ids = @team.characters.pluck(:id)
    else
      @selected_character_ids = session[:selected_character_ids] || []
    end
  end

  def create
    # キャラクターidを取得し整数に変換
    character_ids = params[:character_ids].map(&:to_i)

    # 4体のキャラクターが選択されてなかったらリダイレクト
    if character_ids.size != 4
      # セッションにキャラIDを保存して、リダイレクト
      session[:selected_character_ids] = character_ids
      return redirect_to new_team_rating_path, alert: t('defaults.flash_message.team_ratings.select_four_characters')
    end

    # キャラクターIDからチームを検索する
    team = Team.find_by_character_ids(character_ids)

    if team && current_user.team_ratings.exists?(team_id: team.id)
      # セッションにキャラIDを保存して、リダイレクト
      session[:selected_character_ids] = character_ids
      return redirect_to new_team_rating_path, alert: t('defaults.flash_message.team_ratings.already_team_rated')
    end

    # データベース処理をトランザクションで囲む
    begin
      ActiveRecord::Base.transaction do
        # チームが存在しなければ新規作成
        unless team
          team = Team.create!
          character_ids.each do |character_id|
            team.team_to_characters.create!(character_id: character_id)
          end
        end

        # チーム評価の作成
        @team_rating = current_user.team_ratings.build(team_rating_params)
        @team_rating.team = team
        # 保存
        @team_rating.save!
      end

      session.delete(:selected_character_ids)
      redirect_to team_path(team), notice: t('defaults.flash_message.created', item: TeamRating.model_name.human)
    rescue StandardError => e
      # エラーメッセージを表示
      e.message
      e.record.errors.full_messages.join(', ') if e.is_a?(ActiveRecord::RecordInvalid) && e.record.errors.any?

      # セッションにキャラIDを保存して、リダイレクト
      session[:selected_character_ids] = character_ids
      redirect_to new_team_rating_path, alert: t('defaults.flash_message.not_created', item: TeamRating.model_name.human)
    end
  end

  def edit
    @team = @team_rating.team
  end

  def update
    @team = @team_rating.team

    if @team_rating.update(team_rating_params)
      redirect_to team_path(@team), notice: t('defaults.flash_message.updated', item: TeamRating.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @team = @team_rating.team
    @team_rating_id = @team_rating.id
    @team_rating.destroy

    redirect_to team_path(@team), notice: t('defaults.flash_message.deleted', item: TeamRating.model_name.human)
  end

  private

  # strong params
  def team_rating_params
    params.require(:team_rating).permit(:rating, :body)
  end

  def set_team_rating
    @team_rating = TeamRating.find(params[:id])
  end

  def authorize_user
    return if current_user&.id == @team_rating.user_id

    redirect_to team_rating_path, alert: t('defaults.flash_message.not_authorized')
  end
end
