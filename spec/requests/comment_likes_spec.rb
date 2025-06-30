require 'rails_helper'

RSpec.describe "CommentLikes", type: :request do
  let(:user) { create(:user) }
  let(:test_post) { create(:post) }
  let(:comment) { create(:comment) }

  describe "POST /comments/:comment_id/comment_likes" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "コメントにいいねを作成する" do
        expect {
          post comment_comment_likes_path(comment), headers: {
            'Accept' => 'text/vnd.turbo-stream.html'
          }
        }.to change(CommentLike, :count).by(1)

        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        post comment_comment_likes_path(comment)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE /comments/:comment_id/comment_likes" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      context "コメントにいいねが存在する場合" do
        let!(:comment_like) { create(:comment_like, user: user, comment: comment) }

        it "コメントのいいねを削除する" do
          expect {
            delete comment_comment_likes_path(comment), headers: {
              'Accept' => 'text/vnd.turbo-stream.html'
            }
          }.to change(CommentLike, :count).by(-1)

          expect(response).to have_http_status(:success)
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        delete comment_comment_likes_path(comment)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
