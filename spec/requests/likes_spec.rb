require 'rails_helper'

RSpec.describe LikesController, type: :request do
  let(:user) { create(:user) }
  let(:test_post) { create(:post) }

  describe 'POST /posts/:post_id/likes' do
    context 'ユーザーがログインしている場合' do
      before { login_as(user) }

      it 'いいねを作成する' do
        expect {
          post post_likes_path(test_post), headers: {
            'Accept' => 'text/vnd.turbo-stream.html'
          }
        }.to change(Like, :count).by(1)

        expect(response).to have_http_status(:success)
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        post post_likes_path(test_post)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'DELETE /posts/:post_id/likes' do
    context 'ユーザーがログインしている場合' do
      before { login_as(user) }

      context 'いいねが存在する場合' do
        let!(:like) { create(:like, user: user, post: test_post) }

        it 'いいねを削除する' do
          expect {
            delete post_likes_path(test_post), headers: {
              'Accept' => 'text/vnd.turbo-stream.html'
            }
          }.to change(Like, :count).by(-1)

          expect(response).to have_http_status(:success)
        end
      end
    end

    context 'ユーザーがログインしていない場合' do
      it 'ログインページにリダイレクトされる' do
        delete post_likes_path(test_post)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
