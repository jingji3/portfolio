require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:test_post) { create(:post) }

  describe "POST /posts/:post_id/favorites" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "お気に入りを作成する" do
        expect {
          post post_favorites_path(test_post), headers: {
            'Accept' => 'text/vnd.turbo-stream.html'
          }
        }.to change(Favorite, :count).by(1)

        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        post post_favorites_path(test_post)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE /posts/:post_id/favorites" do
    context "ユーザーがログインしている場合" do
      before { login_as(user)}

      context "お気に入りが存在する場合" do
        let!(:favorite) { create(:favorite, user: user, post: test_post) }

        it "お気に入りを削除する" do
          expect {
            delete post_favorites_path(test_post), headers: {
              'Accept' => 'text/vnd.turbo-stream.html'
            }
          }.to change(Favorite, :count).by(-1)

          expect(response).to have_http_status(:success)
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        delete post_favorites_path(test_post)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
