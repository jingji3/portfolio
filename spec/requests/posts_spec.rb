require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:test_post) { create(:post) }

  describe "GET /posts" do
    context "基本画面の表示" do
      it "正常にページが表示される" do
        get posts_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /posts/:id" do
    context "ポストが存在する場合" do
      it "正常にページが表示される" do
        get post_path(test_post.id)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /posts/new" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "正常にページが表示される" do
        get new_post_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        get new_post_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
