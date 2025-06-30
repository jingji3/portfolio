FactoryBot.define do
  factory :request_to_character do
    association :request
    association :character
  end
end
