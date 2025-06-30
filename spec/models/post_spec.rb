require 'rails_helper'

RSpec.describe Post, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      post = build(:post)
      expect(post).to be_valid
    end
  end

  context 'バリデーション' do
    context 'タイトルが空の場合' do
      it '無効であること' do
        post = build(:post, title: nil)
        expect(post).not_to be_valid
      end
    end

    context '内容が空の場合' do
      it '無効であること' do
        post = build(:post, body: nil)
        expect(post).not_to be_valid
      end
    end

    context 'YoutubeURLが空の場合' do
      it '無効であること' do
        post = build(:post, video_url: nil)
        expect(post).not_to be_valid
      end
    end

    context 'タイトルが255文字を超える場合' do
      it '無効であること' do
        post = build(:post, title: 'a' * 256)
        expect(post).not_to be_valid
      end
    end

    context '内容が65535文字を超える場合' do
      it '無効であること' do
        post = build(:post, body: 'a' * 65536)
        expect(post).not_to be_valid
      end
    end

    context 'YoutubeURLが255文字を超える場合' do
      it '無効であること' do
        post = build(:post, video_url: 'a' * 256)
        expect(post).not_to be_valid
      end
    end
  end
end
