require 'rails_helper'

RSpec.describe "Teams", type: :request do
  let(:team) { create(:team) }

  describe "GET /teams" do
    context "基本画面の表示" do
      it "正常にページが表示される" do
        get teams_path
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "GET /teams/:id" do
    it "正常にページが表示される" do
      get team_path(team.id)
      expect(response).to have_http_status(:success)
    end
  end
end
