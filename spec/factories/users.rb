FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "runteq_#{n}@example.com" }
    user_name { "テストユーザー" }
    password { "Password1010-" }
    password_confirmation { "Password1010-" }
  end
end
