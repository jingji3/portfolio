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

    # タグでの絞り込み
    if params[:tag].present?
      @posts = @posts.joins(:tags).where(tags: { name: params[:tag].downcase })
    end

    @posts = @posts.distinct.page(params[:page]).per(9)

    # YouTube情報の取得
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
    @post.tag_input = params[:post][:tag_input] # 仮フィールドにタグ文字列を渡す

    process_time_params # YouTubeの開始時間を処理

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
    @post.tag_input = @post.tags.map { |t| "##{t.name}"}.join(' ')
  end

  def update
    process_time_params # YouTubeの開始時間を処理
    @post.tag_input = params[:post][:tag_input]

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


  private

  def set_post
    @post = Post.includes(:user, :tags, posts_to_characters: :character).find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :video_url, :youtube_start_time, :tag_input)
  end

  def authorize_user
    return if current_user&.id == @post.user_id

    redirect_to posts_path, alert: t('defaults.flash_message.not_authorized')
  end

  # キャラクターの関連付けを作成するメソッド
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

  # YouTubeの開始時間を処理するメソッド
  def process_time_params
    return unless params[:time].present?

    hours = params[:time][:hours].to_i
    minutes = params[:time][:minutes].to_i
    seconds = params[:time][:seconds].to_i

    total_seconds = (hours * 3600) + (minutes * 60) + seconds
    params[:post][:youtube_start_time] = total_seconds > 0 ? total_seconds : nil
  end
end
