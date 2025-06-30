require 'rails_helper'

RSpec.describe RequestToCharacter, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      request_to_character = build(:request_to_character)
      expect(request_to_character).to be_valid
    end
  end
end
