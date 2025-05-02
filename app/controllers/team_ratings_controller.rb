class TeamRatingsController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: %i[index show]
  before_action :set_team_rating, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]

  def index
    @character_group = get_character_groups
  end

  def new
    @team_rating = TeamRating.new
    @characters = Character.all
  end

  def create
    @team_rating = current_user.team_ratings.build(team_rating_params)
    character_ids = params[:character_ids].map(&:to_i)

    if user_already_rated_team?(character_ids)
      flash[:alert] = '同じキャラクター編成に対する評価はすでに投稿済みです'
      @characters = Character.all
      @selected_character_ids = character_ids
      return render :new

  def show
    @characters = @team_rating.characters
  end

  def edit
    @characters = @team_rating.characters
  end

  def update
    if @team_rating.update(team_rating_params)
      @team_rating.team_rating_to_characters.destroy_all # 既存の関連を削除
      redirect_to team_rating_path(@tema_rating), notice: 'チーム評価を更新しました'
    else
      @characters = @team_rating.characters
      render :edit, status: :unprocessable_entity
  end

  def destroy
    @team_rating.destroy
    redirect_to team_ratings_path, notice: 'チーム評価を削除しました'
  end

  private

  def require_login
    return if current_user

    flash[:alert] = t('defaults.flash_message.require_login')
    redirect_to login_path
  end

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

  # 同じキャラクター4体評価の投稿がないかチェック
  def user_already_rated_team?(character_ids)
    # キャラクターをソートし順序依存をなくす
    sorted_character_ids = character_ids.sort
    # ユーザーの評価情報を取得し、評価キャラidを取得してソート
    current_user.team_rating.each do |rating|
      rating_character_ids = rating.characters.plunk(:id).sort
      # 投稿情報と、取得した情報にて同じキャラかチェックする
      return true if rating_character_ids == sorted_character_ids
    end

    false
  end

  # キャラクターのグループ化と平均評価計算
  def get_character_groups
    all_ratings = TeamRating.icludes(:characters, :user).all

    # キャラクター組み合わせをグループ化するため作成
    character_groups = {}

    # 取得したall_ratingsを分解しratingへ
    all_ratings.each do |rating|
      character_ids = rating.character.pluck(:id).sort # ratingのキャラクターidを取得してソート(キャラクターidのみ)
      key = character_ids.join(',') # キャラクターidを並べる

      # keyをハッシュキーとしてハッシュ構造の定義。グループがなければ初期値化
      character_groups[key] ||= {
        character_ids: character_ids,
        ratings: [],
        average_rating: 0,
        count: 0
      }

      # 各ratingに評価情報を追加、サンプル数割り出しのためカウント
      character_groups[key][:ratings] << rating
      character_groups[key][:count] += 1
    end

    # 各グループの平均評価を計算
    character_groups.each do |_key, group|
      total = group[:ratings].sum(&:rating)
      group[:average_rating] = (total / group[:count].to_f).round(1)
    end

    # 平均値の高い順にソート
    character_groups.value.sort_by { |g| -g[:avarage_rating] }
  end
end
