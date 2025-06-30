require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:team) { create(:team) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      team = build(:team)
      expect(team).to be_valid
    end
  end

  context '#average_rating' do
    it '平均評価を返す' do
      create(:team_rating, team: team, user: user1, rating: 4.0)
      create(:team_rating, team: team, user: user2, rating: 2.0)

      expect(team.average_rating).to eq(3.0)
    end

    it '評価がない場合は0.0を返す' do
      expect(team.average_rating).to eq(0.0)
    end
  end

  context '#ratings_count' do
    it '評価数を返す' do
      create_list(:team_rating, 3, team: team)
      expect(team.ratings_count).to eq(3)
    end

    it '評価がない場合は0を返す' do
      expect(team.ratings_count).to eq(0)
    end
  end
end
