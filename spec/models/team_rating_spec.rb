require 'rails_helper'

RSpec.describe TeamRating, type: :model do
  let(:user) { create(:user) }
  let(:team) { create(:team) }

  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      team_rating = build(:team_rating)
      expect(team_rating).to be_valid
    end
  end

  context '評価バリデーション' do
    it 'ratingがない場合は無効' do
      team_rating = build(:team_rating, user: user, team: team, rating: nil)
      expect(team_rating).not_to be_valid
    end

    it 'rating 0.9 は無効' do
      team_rating = build(:team_rating, user: user, team: team, rating: 0.9)
      expect(team_rating).not_to be_valid
    end

    fit 'rating 1.0 は有効' do
      team_rating = build(:team_rating, user: user, team: team, rating: 1.0)
      expect(team_rating).to be_valid
    end

    it '同じユーザーが同じチームを重複評価できない' do
      create(:team_rating, user: user, team: team)
      duplicate_rating = build(:team_rating, user: user, team: team)
      expect(duplicate_rating).not_to be_valid
    end
  end
end
