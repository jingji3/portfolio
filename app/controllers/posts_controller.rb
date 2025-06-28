class PostsController < ApplicationController
  include CharacterSelect # concernsのキャラクター選択用メソッド

  skip_before_action :require_login, only: %i[index show]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]
  before_action :set_characters_data, only: %i[index new edit create update] # キャラクターデータをセット

  include YoutubeHelper

  def index
    # キャラクター検索用のパラメータを処理
    character_ids = []
    (1..4).each do |i|
      character_id = params["character#{i}"]
      character_ids << character_id if character_id.present?
    end

    @posts = Post.includes(:user, posts_to_characters: :character)

    # ポストの表示順を変えるための処理
    @posts = case params[:sort]
    when "likes"
                @posts.left_joins(:likes) # 　joinsでまとめるとlike0のpostが取得されないため、left_joinsを使用
                      .select("posts.*, COUNT(likes.id) as likes_count")
                      .group("posts.id")
                      .order("likes_count DESC, posts.created_at DESC")
    else
                @posts.order(created_at: :desc)
    end


    # キャラクターIDが指定されている場合は絞り込み
    if character_ids.any?
      # 全ての選択されたキャラクターを含む投稿のみを取得（AND検索）
      @posts = @posts.joins(:posts_to_characters)
                     .where(posts_to_characters: { character_id: character_ids })
                     .group("posts.id")
                     .having("COUNT(DISTINCT posts_to_characters.character_id) = ?", character_ids.size)
    end

    # タグでの絞り込み
    if params[:tag].present?
      @posts = @posts.joins(:tags).where(tags: { name: params[:tag].downcase })
    end

    @posts = @posts.distinct.page(params[:page]).per(12)

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

    # 通知画面からの遷移時に自動でキャラクターパラメータの作成したURLで開く
    handle_preselected_characters
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.tag_input = params[:post][:tag_input] # 仮フィールドにタグ文字列を渡す

    process_time_params # YouTubeの開始時間を処理

    if @post.save
      create_character_associations
      check_and_complete_matching_requests(@post) # もしリクエストがあるキャラクターの編成だった場合にstatusをcompleteにする
      redirect_to @post, notice: t("defaults.flash_message.shared", item: Post.model_name.human)
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
    @post.tag_input = @post.tags.map { |t| "##{t.name}" }.join(" ")
  end

  def update
    process_time_params # YouTubeの開始時間を処理
    @post.tag_input = params[:post][:tag_input]

    if @post.update(post_params)
      @post.posts_to_characters.destroy_all # 既存の関連を削除
      create_character_associations # 新しい関連を作成

      redirect_to @post, notice: t("defaults.flash_message.updated", item: Post.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: t("defaults.flash_message.deleted", item: Post.model_name.human)
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

    redirect_to posts_path, alert: t("defaults.flash_message.not_authorized")
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

  # リクエストの自動完了
  def check_and_complete_matching_requests(post)
    # 投稿のキャラクターIDを取得（constellation順でソート）
    post_character_ids = post.posts_to_characters
                            .order(:id)
                            .pluck(:character_id)

    return if post_character_ids.empty?

    # 同じキャラクター構成のpendingリクエストを検索
    matching_requests = find_matching_requests(post_character_ids)

    # マッチしたリクエストを完了にして通知送信
    matching_requests.each do |request|
      request.update!(status: :completed)
      send_request_completed_notification(request, post_character_ids)
    end

    Rails.logger.info "#{matching_requests.count}件のリクエストが自動完了しました" if matching_requests.any?
  end

  # 同じキャラクター構成のpendingリクエストを検索
  def find_matching_requests(post_character_ids)
    # pendingステータスのリクエストを取得
    pending_requests = Request.pending.includes(:request_to_characters)

    # 各リクエストのキャラクター構成と完全一致するものを抽出
    pending_requests.select do |request|
      request_character_ids = request.request_to_characters
                                    .order(:id)
                                    .pluck(:character_id)

      # 配列の要素と順序が完全一致するかチェック
      post_character_ids.sort == request_character_ids.sort
    end
  end

  # リクエスト完了通知を送信
  def send_request_completed_notification(request, character_ids)
    # キャラクター名を取得
    character_names = Character.where(id: character_ids).pluck(:name)

    # リクエスト作成者に完了通知を送信
    RequestCompletedNotifier.with(
      record: request,
      character_names: character_names,
      character_ids: character_ids
    ).deliver(request.user)
  end

  # 通知一覧から事前選択されたキャラクターでPostsToCharacterを作成
  def handle_preselected_characters
    if params[:character_ids].present?
      character_ids = params[:character_ids].map(&:to_i)

      # 事前選択されたキャラクターでPostsToCharacterを作成（メモリ上のみ）
      character_ids.each_with_index do |character_id, index|
        character = Character.find_by(id: character_id)
        if character
          @post.posts_to_characters.build(
            character_id: character_id,
            constellation: 0 # デフォルト値
          )
        end
      end
    end
  end
end
