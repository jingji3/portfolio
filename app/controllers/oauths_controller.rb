class OauthsController < ApplicationController
  skip_before_action :require_login
  # OAuth認証プロセスを開始するアクション
  def oauth
    login_at(params[:provider])
  end

  # OAuth認証後にGoogleからリダイレクトされるコールバックアクション
  def callback
    provider = params[:provider]

    # すでにこのアカウントでログインしたことがあるかの確認
    if @user = login_from(provider)
      # ログイン済みならそのままログイン処理
      redirect_to posts_path, notice: "#{provider.titleize}でログインしました"
    else
      begin
        # 初めてのOAuthログインなら新規ユーザーを作成
        @user = create_from(provider)
        reset_session
        auto_login(@user)
        redirect_to posts_path, notice: "#{provider.titleize}アカウントで登録・ログインしました"
      rescue StandardError
        # エラーが発生した場合
        redirect_to posts_path, alert: "#{provider.titleize}アカウントでのログインに失敗しました"
      end
    end
  end

  private

  # OAuthプロバイダーの情報からユーザーを作成するメソッド
  def create_from(provider)
    sorcery_fetch_user_hash(provider) # Googleからユーザー情報を取得
    @user = User.find_by(email: @user_hash[:user_info]["email"]) # すでに同じメールアドレスユーザーが存在しないか確認

    unless @user
      # ランダムパスワード生成
      random_password = SecureRandom.hex(10)

      @user = User.new(
        email: @user_hash[:user_info]["email"],
        user_name: @user_hash[:user_info]["name"],
        password: random_password,
        password_confirmation: random_password,
        oauth_login: true
      )
      @user.save!
    end

    # このユーザーとOAuth認証情報を関連付け
    unless @user.authentications.find_by(provider: provider, uid: @user_hash[:uid])
      @user.authentications.create!(provider: provider, uid: @user_hash[:uid])
    end

    @user
  end
end
