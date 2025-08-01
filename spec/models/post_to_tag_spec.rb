require 'rails_helper'

RSpec.describe PostToTag, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      post_to_tag = build(:post_to_tag)
      expect(post_to_tag).to be_valid
    end
  end
end
