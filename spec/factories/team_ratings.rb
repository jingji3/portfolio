FactoryBot.define do
  factory :team_rating do
    association :team
    association :user
    body { "素晴らしいチーム！" }
    rating { 4.5 }
  end
end
