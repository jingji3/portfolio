require 'rails_helper'

RSpec.describe PostsToCharacter, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      posts_to_character = build(:posts_to_character)
      expect(posts_to_character).to be_valid
    end
  end

  context 'バリデーション' do
    context 'constellation' do
      it 'constellationが存在しない場合は無効' do
        posts_to_character = build(:posts_to_character, constellation: nil)
        expect(posts_to_character).not_to be_valid
      end

      it 'constellationが0の場合は有効' do
        posts_to_character = build(:posts_to_character, constellation: 0)
        expect(posts_to_character).to be_valid
      end

      it 'constellationが6の場合は有効' do
        posts_to_character = build(:posts_to_character, constellation: 6)
        expect(posts_to_character).to be_valid
      end

      it 'constellationが7の場合は無効' do
        posts_to_character = build(:posts_to_character, constellation: 7)
        expect(posts_to_character).not_to be_valid
      end
    end
  end
end
