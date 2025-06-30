FactoryBot.define do
  factory :post_to_tag do
    association :post
    association :tag
  end
end
