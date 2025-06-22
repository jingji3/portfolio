class TeamsController < ApplicationController
  include CharacterSelect #concernsのキャラクター選択用メソッド

  skip_before_action :require_login, only: %i[index show]
  before_action :set_characters_data, only: %i[index] #キャラクターデータをセット

  def index
    @teams = case params[:sort]
              when 'updated_at'
                @teams = Team.includes(:characters).order(updated_at: :desc)
              else
                # 表示を評価順に表示させるためにまとめる
                @teams = Team.joins(:team_ratings)
                            .select('teams.*, AVG(team_ratings.rating) as average_rating, COUNT(team_ratings.id) as ratings_count')
                            .group('teams.id')
                            .order('average_rating DESC')
                            .includes(:characters)
              end

    # キャラクター検索用のパラメータを処理
    character_ids = []
    (1..4).each do |i|
      character_id = params["character#{i}"]
      character_ids << character_id if character_id.present?
    end

    # キャラクターIDが指定されている場合は絞り込み
    if character_ids.any?
      # 全ての選択されたキャラクターを含む投稿のみを取得（AND検索）
      @teams = @teams.joins(:team_to_characters)
                     .where(team_to_characters: { character_id: character_ids })
                     .group('teams.id')
                     .having('COUNT(DISTINCT team_to_characters.character_id) = ?', character_ids.size)
    end

    @teams = @teams.distinct.page(params[:page]).per(8)
  end

  def show
    @team = Team.find(params[:id])
    @characters = @team.characters
    @ratings = @team.team_ratings.includes(:user)
    @average = @team.team_ratings.average(:rating).to_f.round(1)

    # 現在のユーザーがこのチームを評価しているか確認
    return unless user_signed_in?

    @user_rating = current_user.team_ratings.find_by(team_id: @team.id)
    @new_rating = TeamRating.new if @user_rating.nil?
  end
end
