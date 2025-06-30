require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  let(:user) { create(:user) }

  describe "POST /login" do
    context "基本画面の表示" do
      it "ログインページが表示される" do
        get login_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインに成功する正しい情報" do
      it "ログインに成功" do
        post login_path, params: { email: user.email, password: "Password1010-" }
        expect(response).to redirect_to(posts_path)
      end
    end

    context "ログインに失敗する情報" do
      it "ログインに失敗" do
        post login_path, params: { email: user.email, password: "wrongpassword" }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("ログインに失敗しました")
      end
    end
  end

  describe "DELETE /logout" do
    context "ログアウト" do
      before { login_as(user) }  # ユーザーをログイン状態にする

      it "ログアウトに成功" do
        delete logout_path
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
