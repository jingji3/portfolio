class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :posts, dependent: :destroy
  has_one_attached :avatar

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :user_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "は有効な画像形式である必要があります" },
                    size: { less_than: 5.megabytes,
                           message: "は5MB未満である必要があります" },
                    allow_blank: true

  enum role: { general: 0, admin: 1 }

  # パスワードが空の場合は更新しない
  attr_accessor :skip_password_validation

  # admin判断のため
  def admin?
    role == "admin"
  end

  # Ransackで検索可能な属性を定義
  def self.ransackable_attributes(auth_object = nil)
    # 安全に検索できると判断した属性のみリストに含める
    # パスワード関連は除外することをお勧めします
    ["id", "user_name", "email", "role", "created_at", "updated_at"]
  end

  # Ransackで検索可能な関連を定義
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
