require 'rails_helper'

RSpec.describe Comment, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      comment = build(:comment)
      expect(comment).to be_valid
    end
  end

  context 'バリデーション' do
    it 'commentが空の場合、無効であること' do
      comment = build(:comment, comment: nil)
      expect(comment).not_to be_valid
      expect(comment.errors[:comment]).to include("を入力してください")
    end

    it 'commentが65535文字を超える場合、無効であること' do
      comment = build(:comment, comment: 'a' * 65536)
      expect(comment).not_to be_valid
      expect(comment.errors[:comment]).to include("は65535文字以内で入力してください")
    end
  end
end
