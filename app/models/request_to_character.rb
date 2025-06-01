class RequestToCharacter < ApplicationRecord
  belongs_to :request
  belongs_to :character

  validates :request_id, uniqueness: { scope: :character_id, message: 'このキャラクターはすでに存在します' }

  private

  def self.ransackable_attributes(auth_object = nil)
    ["character_id", "request_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
