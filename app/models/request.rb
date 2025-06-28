class Request < ApplicationRecord
  belongs_to :user
  has_many :request_to_characters, dependent: :destroy
  has_many :characters, through: :request_to_characters

  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"

  validates :user_id, presence: true
  validates :message, length: { maximum: 500 }, allow_blank: true

  enum status: {
    pending: 0,
    completed: 1,
    canceled: 2
  }

  # キャラクター名を文字列で返す
  def character_names
    characters.pluck(:name).join(", ")
  end

  def character_count
    characters.count
  end
end
