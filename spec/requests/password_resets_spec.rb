require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  let(:user) { create(:user) }

  describe "GET /password_resets/new" do
    it "パスワードリセット画面が表示される" do
      get new_password_reset_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /password_resets" do
    context "存在するメールアドレスの場合" do
      it "ログインページにリダイレクトされる" do
        post password_resets_path, params: { email: user.email }

        expect(response).to redirect_to(login_path)
        expect(flash[:success]).to be_present
      end
    end

    context "存在しないメールアドレスの場合" do
      it "ログインページにリダイレクトされる（セキュリティのため同じ動作）" do
        post password_resets_path, params: { email: "nonexistent@example.com" }

        expect(response).to redirect_to(login_path)
        expect(flash[:success]).to be_present
      end
    end

    context "空のメールアドレスの場合" do
      it "ログインページにリダイレクトされる" do
        post password_resets_path, params: { email: "" }

        expect(response).to redirect_to(login_path)
      end
    end
  end
end
