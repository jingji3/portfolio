require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:test_post) { create(:post) }

  describe "POST /posts/:post_id/comments" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "コメントを作成する" do
        expect {
          post post_comments_path(test_post),
          params: { comment: { comment: "テストコメント" } },
          headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        post post_comments_path(test_post)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  # shallow trueを使用しているため、コメントの削除や更新はコメントのIDのみでアクセス可能
  describe "DELETE /comments/:id" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      context "コメントが存在する場合" do
        let!(:comment) { create(:comment, user: user, post: test_post) }

        it "コメントを削除する" do
          expect {
            delete comment_path(comment),
            headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
          }.to change(Comment, :count).by(-1)

          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe "PATCH /comments/:id" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      context "コメントが存在する場合" do
        let!(:comment) { create(:comment, user: user, post: test_post) }

        it "コメントを更新する" do
          patch comment_path(comment),
          params: { comment: { comment: "更新されたコメント" } },
          headers: { 'Accept' => 'text/vnd.turbo-stream.html' }

          comment.reload
          expect(comment.comment).to eq("更新されたコメント")
          expect(response).to have_http_status(:success)
        end
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        patch comment_path(id: 1)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
