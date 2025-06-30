require 'rails_helper'

RSpec.describe "TeamRatings", type: :request do
  let(:user) { create(:user) }
  let(:team) { create(:team) }
  let(:team_rating) { create(:team_rating, user: user, team: team) }
  let!(:characters) { create_list(:character, 4) }  # 4つのキャラクターを作成（let!とすることでこの時点で4体作る）
  let(:other_user) { create(:user, email: "other@example.com") }
  let(:other_team_rating) { create(:team_rating, user: other_user, team: team) }

  describe "GET /team_ratings/new" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "正常にページが表示される" do
        get new_team_rating_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        get new_team_rating_path
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST /team_ratings" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "新しいチーム評価を作成する" do
        expect {
          post team_ratings_path, params: {
            character_ids: characters.map(&:id),
            team_rating: { rating: 4.5, body: "素晴らしいチーム！" }
          }
        }.to change(TeamRating, :count).by(1)
        expect(response).to have_http_status(:redirect)
      end

      it "キャラクターが4体未満の場合にリダイレクトされる" do
        post team_ratings_path, params: {
          character_ids: [ characters.first.id ],  # 1体のみ
          team_rating: { rating: 4.5, body: "test" }
        }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(new_team_rating_path)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        post team_ratings_path, params: {
          character_ids: characters.map(&:id),
          team_rating: { rating: 4.5, body: "素晴らしいチーム！" }
        }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "GET /team_ratings/:id/edit" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "編集ページが表示される（Turbo Stream）" do
        get edit_team_rating_path(team_rating), headers: {
          'Accept' => 'text/vnd.turbo-stream.html'  # Turbo Stream形式
        }
        expect(response).to have_http_status(:success)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        get edit_team_rating_path(team_rating)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "PATCH /team_ratings/:id" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "チーム評価を更新する" do
        patch team_rating_path(team_rating), params: {
          character_ids: characters.map(&:id),
          team_rating: {
            rating: 5.0,
            body: "素晴らしいチーム！"
          }
        }
        expect(response).to have_http_status(:redirect)
        team_rating.reload
        expect(team_rating.rating).to eq(5.0)
        expect(team_rating.body).to eq("素晴らしいチーム！")
      end

      it "他人のチーム評価を更新しようとすると権限エラーになる" do
        other_team_rating  # other_user作成のteam_rating
        patch team_rating_path(other_team_rating), params: {
          character_ids: characters.map(&:id),
          team_rating: {
            rating: 5.0,
            body: "素晴らしいチーム！"
          }
        }
        expect(response).to have_http_status(:redirect)
        expect(other_team_rating.reload.rating).not_to eq(5.0)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        patch team_rating_path(team_rating), params: {
          character_ids: characters.map(&:id),
          team_rating: {
            rating: 5.0,
            body: "素晴らしいチーム！"
          }
        }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "DELETE /team_ratings/:id" do
    context "ユーザーがログインしている場合" do
      before { login_as(user) }

      it "自分のチーム評価を削除する" do
        team_rating
        expect {
          delete team_rating_path(team_rating)
        }.to change(TeamRating, :count).by(-1)
        expect(response).to have_http_status(:redirect)
      end

      it "他人のチーム評価を削除しようとすると権限エラーになる" do
        other_team_rating
        expect {
          delete team_rating_path(other_team_rating)
        }.not_to change(TeamRating, :count)
        expect(response).to have_http_status(:redirect)
      end
    end

    context "ユーザーがログインしていない場合" do
      it "ログインページにリダイレクトされる" do
        delete team_rating_path(team_rating)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
