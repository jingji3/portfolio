FactoryBot.define do
  factory :character do
    sequence(:name) { |n| "キャラクター#{n}" }
    sequence(:name_kana) { |n| "キャラクター#{n}" }
    sequence(:name_eng) { |n| "Character#{n}" }
    element { 0 }
    star { 5 }
    version { "1.0" }
    version_half { 0 }
  end
end
