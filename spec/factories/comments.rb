FactoryBot.define do
  factory :comment do
    comment { "テストコメント" }
    association :user
    association :post
  end
end
