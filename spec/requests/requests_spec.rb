require 'rails_helper'

RSpec.describe "Requests", type: :request do
  let(:user) { create(:user) }
  let!(:character1) { create(:character, name: "キャラA") }
  let!(:character2) { create(:character, name: "キャラB") }
  let!(:character3) { create(:character, name: "キャラC") }
  let!(:character4) { create(:character, name: "キャラD") }

  describe "GET /requests/new" do
    context "ログインユーザーの場合" do
      before { login_as(user) }

      it "新規リクエスト画面が表示される" do
        get new_request_path
        expect(response).to have_http_status(:success)
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get new_request_path
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
