require 'rails_helper'

RSpec.describe TeamToCharacter, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      team_to_character = build(:team_to_character)
      expect(team_to_character).to be_valid
    end
  end
end
