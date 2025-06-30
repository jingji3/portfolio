class RequestToCharacter < ApplicationRecord
  belongs_to :request
  belongs_to :character

  validates :request_id, uniqueness: { scope: :character_id }
end
