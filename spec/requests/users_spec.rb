require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    context "新規登録画面の表示" do
      it "新規登録ページが表示される" do
        get new_user_path
        expect(response).to have_http_status(:success)
      end
    end

    context "新規登録に成功する正しい情報" do
      it "新規登録に成功" do
        expect {
          post users_path, params: {
            user: {
              user_name: "テスト",
              email: "test2@example.com",
              password: "Password1010-",
              password_confirmation: "Password1010-"
            }
          }
        }.to change(User, :count).by(1)

        expect(response).to redirect_to(login_path)
      end
    end

    context "新規登録に失敗する情報" do
      it "新規登録に失敗" do
        expect {
          post users_path, params: {
            user: {
              user_name: "",
              email: "invalid_email",
              password: "short",
              password_confirmation: "different"
            }
          }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end
end
