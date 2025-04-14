class PostsController < ApplicationController
  before_action :require_login
  skip_before_action :require_login, only: %i[index show]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]

  def index
    @characters = Character.all.order(:name)

    # キャラクター検索用のパラメータを処理
    character_ids = []
    (1..4).each do |i|
      character_id = params["character#{i}"]
      character_ids << character_id if character_id.present?
    end

    @posts = Post.includes(:user, posts_to_characters: :character).order(created_at: :desc)

    # キャラクターIDが指定されている場合は絞り込み
    if character_ids.any?
      # 全ての選択されたキャラクターを含む投稿のみを取得（AND検索）
      @posts = @posts.joins(:posts_to_characters)
                      .where(posts_to_characters: { character_id: character_ids })
                      .group('posts.id')
                      .having('COUNT(DISTINCT posts_to_characters.character_id) = ?', character_ids.size)
    end

    @posts = @posts.distinct.page(params[:page]).per(10)
  end

  def show
    @post = Post.includes(:user, posts_to_characters: :character).find(params[:id])
  end

  def new
    @post = Post.new
    @characters = Character.all.order(:name)
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      create_character_associations
      redirect_to @post, notice: '投稿が作成されました'
    else
      @characters = Character.all.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.includes(:user, posts_to_characters: :character).find(params[:id])
    @characters = Character.all.order(:name)
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      @post.posts_to_characters.destroy_all # 既存の関連を削除
      create_character_associations # 新しい関連を作成

      redirect_to @post, notice: '投稿が更新されました'
    else
      @characters = Character.all.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])

    if current_user.id == @post.user_id
      @post.destroy
      redirect_to posts_path, notice: "投稿を削除しました"
    else
      redirect_to post_path(@post), alert: "削除権限がありません"
    end
  end

  private

  def require_login
    unless current_user
      flash[:alert] = "ログインが必要です"
      redirect_to login_path
    end
  end

  def set_post
    @post = Post.includes(:user, posts_to_characters: :character).find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :video_url)
  end

  def authorize_user
    unless current_user&.id == @post.user_id
      redirect_to posts_path, alert: "操作を行うアカウント権限がありません"
    end
  end

  def create_character_associations
    return unless params[:character_ids].present?

    params[:character_ids].each_with_index do |character_id, index|
      next if character_id.blank?

      constellation = params[:constellations][index]
      @post.posts_to_characters.create(
        character_id: character_id,
        constellation: constellation
      )
    end
  end
end
