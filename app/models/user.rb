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

  has_one_attached :avatar

  # OAuthログイン用フラグ
  attr_accessor :oauth_login

  validates :password, length: { minimum: 8 },
                       if: -> { (new_record? || changes[:crypted_password]) && !oauth_login }
  validates :password, format: {
                         with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>\-+_=;:'"])[A-Za-z\d!@#$%^&*(),.?":{}|<>\-+_=;:'"]{8,}\z/,
                         message: 'は8文字以上で、英小文字・英大文字・数字・記号をそれぞれ1つ以上含む必要があります'
                       },
                       if: -> { (new_record? || changes[:crypted_password]) && !oauth_login }
  validates :password, confirmation: true,
                       if: -> { (new_record? || changes[:crypted_password]) && !oauth_login }
  validates :password_confirmation, presence: true,
                                    if: -> { (new_record? || changes[:crypted_password]) && !oauth_login }
  validates :user_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                                     message: 'は有効な画像形式である必要があります' },
                     size: { less_than: 5.megabytes,
                             message: 'は5MB未満である必要があります' },
                     allow_blank: true

  enum role: { general: 0, admin: 1 }

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

  # Ransackで検索可能な属性を定義
  def self.ransackable_attributes(_auth_object = nil)
    # 安全に検索できると判断した属性のみリストに含める
    # パスワード関連は除外することをお勧めします
    %w[id user_name email role created_at updated_at]
  end

  # Ransackで検索可能な関連を定義
  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
