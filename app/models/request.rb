class Request < ApplicationRecord
  belongs_to :user
  has_many :request_to_characters, dependent: :destroy
  has_many :characters, through: :request_to_characters

  validates :user_id, presence: true
  validates :message, presence: true, length: { maximum: 500 }

  enum status: {
    pending: 0,
    completed: 1,
    canceled: 2
  }

  # キャラクター名を文字列で返す
  def character_names
    characters.pluck(:name).join(', ')
  end

  def character_count
    characters.count
  end
end
