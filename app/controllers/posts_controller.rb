class PostsController < ApplicationController
  skip_before_action :require_login, only: %i[index show]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]

  include YoutubeHelper

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

    @posts = @posts.distinct.page(params[:page]).per(9)

    @youtube_info = {}
    youtube_service = YoutubeService.new

    # 動画情報の取得
    @posts.each do |post|
      video_id = extract_youtube_id(post.video_url)

      if video_id
        video_data = youtube_service.get_video_info(video_id)

        if video_data&.items.any?
          channel_id = video_data.items.first.snippet.channel_id
          channel_data = youtube_service.get_channel_info(channel_id)

          @youtube_info[post.id] = {
            video_data: video_data,
            channel_data: channel_data
          }
        end
      end
    end
  end

  def new
    @post = Post.new
    @characters = Character.all.order(:name)
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      create_character_associations
      redirect_to @post, notice: t('defaults.flash_message.created', item: Post.model_name.human)
    else
      @characters = Character.all.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)

    # 動画情報の取得
    video_id = extract_youtube_id(@post.video_url)

    if video_id
      youtube_service = YoutubeService.new
      @video_data = youtube_service.get_video_info(video_id)

      if @video_data&.items.any?
        channel_id = @video_data.items.first.snippet.channel_id
        @channel_data = youtube_service.get_channel_info(channel_id)
      end
    end
  end

  def edit
    @characters = Character.all.order(:name)
  end

  def update
    if @post.update(post_params)
      @post.posts_to_characters.destroy_all # 既存の関連を削除
      create_character_associations # 新しい関連を作成

      redirect_to @post, notice: t('defaults.flash_message.updated', item: Post.model_name.human)
    else
      @characters = Character.all.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: t('defaults.flash_message.deleted', item: Post.model_name.human)
  end

  def favorites
    @favorite_posts = current_user.favorite_posts.includes(:user,
                                                           posts_to_characters: :character).order(created_at: :desc).distinct.page(params[:page]).per(10)
  end

  private

  def set_post
    @post = Post.includes(:user, posts_to_characters: :character).find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :video_url)
  end

  def authorize_user
    return if current_user&.id == @post.user_id

    redirect_to posts_path, alert: t('defaults.flash_message.not_authorized')
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
