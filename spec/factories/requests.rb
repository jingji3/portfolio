FactoryBot.define do
  factory :request do
    association :user, strategy: :create # user_idを自動生成するため
    message { "テストメッセージ" }
    status { "pending" }

    trait :with_characters do
      after(:create) do |request|
        create_list(:request_to_character, 4, request: request)
      end
    end
  end
end
