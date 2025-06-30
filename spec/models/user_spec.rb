require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'パスワードバリデーション' do
    context '新規ユーザーの場合' do
      it 'パスワードが8文字以上であること' do
        user = build(:user, password: '1234567', password_confirmation: '1234567')
        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end

      it '有効なパスワード形式であること' do
        user = build(:user, password: 'ValidPass123!', password_confirmation: 'ValidPass123!')
        expect(user).to be_valid
      end

      it '無効なパスワード形式（大文字なし）で失敗すること' do
        user = build(:user, password: 'invalidpass123!', password_confirmation: 'invalidpass123!')
        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end

      it '無効なパスワード形式（小文字なし）で失敗すること' do
        user = build(:user, password: 'INVALIDPASS123!', password_confirmation: 'INVALIDPASS123!')
        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end

      it '無効なパスワード形式（数字なし）で失敗すること' do
        user = build(:user, password: 'InvalidPass!', password_confirmation: 'InvalidPass!')
        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end

      it '無効なパスワード形式（記号なし）で失敗すること' do
        user = build(:user, password: 'InvalidPass123', password_confirmation: 'InvalidPass123')
        expect(user).to be_invalid
        expect(user.errors[:password]).to be_present
      end

      it 'パスワード確認が一致していること' do
        user = build(:user, password: 'ValidPass123!', password_confirmation: 'DifferentPass123!')
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to be_present
      end

      it 'パスワード確認が存在すること' do
        user = build(:user, password: 'ValidPass123!', password_confirmation: '')
        expect(user).to be_invalid
        expect(user.errors[:password_confirmation]).to be_present
      end
    end

    context 'OAuthログインの場合' do
      it 'パスワードバリデーションがスキップされること' do
        user = build(:user, password: nil, password_confirmation: nil, oauth_login: true)
        expect(user).to be_valid
      end
    end

    context 'パスワード更新の場合' do
      let(:user) { create(:user) }

      it 'パスワード変更時にバリデーションが適用されること' do
        user.password = 'short'
        user.password_confirmation = 'short'
        expect(user).to be_invalid
      end
    end
  end

  describe 'その他のバリデーション' do
    it 'user_nameが必須であること' do
      user = build(:user, user_name: '')
      expect(user).to be_invalid
      expect(user.errors[:user_name]).to be_present
    end

    it 'user_nameが255文字以下であること' do
      user = build(:user, user_name: 'a' * 256)
      expect(user).to be_invalid
      expect(user.errors[:user_name]).to be_present
    end

    it 'emailが必須であること' do
      user = build(:user, email: '')
      expect(user).to be_invalid
      expect(user.errors[:email]).to be_present
    end

    it 'emailが一意であること' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).to be_invalid
      expect(user.errors[:email]).to be_present
    end

    it 'reset_password_tokenが一意であること（nilは除く）' do
      create(:user, reset_password_token: 'unique_token')
      user = build(:user, reset_password_token: 'unique_token')
      expect(user).to be_invalid
      expect(user.errors[:reset_password_token]).to be_present
    end

    it 'reset_password_tokenがnilの場合は有効であること' do
      user = build(:user, reset_password_token: nil)
      expect(user).to be_valid
    end
  end
end
