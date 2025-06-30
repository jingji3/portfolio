require 'rails_helper'

RSpec.describe Tag, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      tag = build(:tag)
      expect(tag).to be_valid
    end
  end

  context 'バリデーション' do
    context 'メッセージが50文字を超える場合' do
      it '無効であること' do
        tag = build(:tag, name: 'a' * 51)
        expect(tag).not_to be_valid
      end
    end
  end
end
