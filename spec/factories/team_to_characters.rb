FactoryBot.define do
  factory :team_to_character do
    association :team
    association :character
  end
end
