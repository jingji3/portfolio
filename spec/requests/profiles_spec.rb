require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { create(:user) }

  describe "GET /profiles" do
    context "ログインユーザーの場合" do
      before { login_as(user) }

      it "正常にページが表示される" do
        get profile_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログインページにリダイレクトされる" do
        get profile_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /profiles/edit" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "編集ページが表示される" do
        get edit_profile_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        get edit_profile_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH /team_ratings/:id" do
  end
end
