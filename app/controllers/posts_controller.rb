class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def index
    @posts = Post.includes(:user, posts_to_characters: :character).order(created_at: :desc).page(params[:page]).per(10)
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
      render :new
    end
  end

  def edit
    authorize @post

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

  def set_post
    @post = Post.includes(:user, :characters).find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :video_url)
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
