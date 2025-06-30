require 'rails_helper'

RSpec.describe "Mypage", type: :request do
  let(:user) { create(:user) }

  describe "GET /mypage" do
    context "ログインユーザーの場合" do
      before { login_as(user) }

      it "正常にページが表示される" do
        get mypage_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログインページにリダイレクトされる" do
        get mypage_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end

    context "タブの確認" do
      let!(:test_post) { create(:post, user: user) }
      let!(:other_post) { create(:post) }
      let!(:favorite) { create(:favorite, user: user, post: other_post) }
      let!(:team_rating) { create(:team_rating, user: user) }

      before { login_as(user) }

      context "postsタブの場合" do
        it "ユーザーの投稿一覧が表示される" do
          get mypage_path, params: { tab: "posts" }

          expect(response).to have_http_status(:success)
          expect(response.body).to include(test_post.title)
        end
      end

      context "favoritesタブの場合" do
        it "お気に入り投稿一覧が表示される" do
          get mypage_path, params: { tab: "favorites" }

          expect(response).to have_http_status(:success)
          expect(response.body).to include(other_post.title)
        end
      end

      context "team_ratingsタブの場合" do
        it "評価一覧が表示される" do
          get mypage_path, params: { tab: "team_ratings" }

          expect(response).to have_http_status(:success)
          expect(response.body).to include("評価")
        end
      end

      # noticedは後ほど詰める
      context "notificationsタブの場合" do
        it "通知一覧が表示される" do
          get mypage_path, params: { tab: "notifications" }

          expect(response).to have_http_status(:success)
          expect(response.body).to include("通知")
        end
      end
    end
  end
end
