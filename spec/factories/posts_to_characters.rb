FactoryBot.define do
  factory :posts_to_character do
    association :post
    association :character
    constellation { 0 }
  end
end
