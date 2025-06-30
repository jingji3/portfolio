require 'rails_helper'

RSpec.describe CommentLike, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      comment_like = build(:comment_like)
      expect(comment_like).to be_valid
    end
  end
end
