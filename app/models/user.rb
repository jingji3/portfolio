class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :comments, dependent: :destroy
  has_many :comment_likes, dependent: :destroy
  has_many :team_ratings, dependent: :destroy
  has_many :rated_teams, through: :team_ratings, source: :team
  has_many :authentications, dependent: :destroy # 複数の認証方法(Google, Xなど)を持たせるため
  has_many :requests, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification" # 通知関連（gem noticed）

  has_one_attached :avatar

  # リクエスト投稿時に自動で完了にする
  after_create :complete_matching_requests

  # OAuthログイン用フラグ
  attr_accessor :oauth_login

  validates :password, length: { minimum: 8 },
                       if: -> { (new_record? || changes[:crypted_password]) && !oauth_login }
  validates :password, format: {
                         with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>\-+_=;:'"])[A-Za-z\d!@#$%^&*(),.?":{}|<>\-+_=;:'"]{8,}\z/,
                         },
                       if: -> { (new_record? || changes[:crypted_password]) && !oauth_login }
  validates :password, confirmation: true,
                       if: -> { (new_record? || changes[:crypted_password]) && !oauth_login }
  validates :password_confirmation, presence: true,
                                    if: -> { (new_record? || changes[:crypted_password]) && !oauth_login }
  validates :user_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png image/webp] },
                     size: { less_than: 5.megabytes }, allow_blank: true
  validates :reset_password_token, uniqueness: true, allow_nil: true

  enum role: { general: 0, admin: 1 }

  # 通知設定のスコープ
  scope :receives_request_notifications, -> { where(receive_request_notifications: true) }

  # パスワードが空の場合は更新しない
  attr_accessor :skip_password_validation

  # ユーザー作成時に認証情報も同時に保存できるようにする
  accepts_nested_attributes_for :authentications

  # admin判断のため
  def admin?
    role == 'admin'
  end

  def own?(object)
    id == object&.user_id
  end

  # 通知設定のメソッド
  def request_notifications_enabled?
    receive_request_notifications
  end

  def enable_request_notifications!
    update!(receive_request_notifications: true)
  end

  def disable_request_notifications!
    update!(receive_request_notifications: false)
  end

  # Ransackで検索可能な属性を定義
  def self.ransackable_attributes(_auth_object = nil)
    %w[id user_name email role created_at updated_at]
  end

  # Ransackで検索可能な関連を定義
  def self.ransackable_associations(_auth_object = nil)
    []
  end

  private

  def complete_matching_requests
    character_ids = posts_to_characters.pluck(:character_id)
    return if character_ids.empty?

    # 一致する全ての未完了リクエストを取得
    matching_requests = Request.find_matching_pending_requests(character_ids)

    # 複数のリクエストがあれば、それぞれを完了状態にして通知
    matching_requests.each do |request|
      request.update!(status: :completed)
    end
  end
end
