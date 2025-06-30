FactoryBot.define do
  factory :post do
    association :user
    title { "テスト投稿" }
    body { "テスト投稿の内容です" }
    video_url { "https://www.youtube.com/watch?v=example" }
    youtube_start_time { 0 }

    trait :with_characters do
      after(:create) do |post|
        characters = create_list(:character, 4)
        characters.each do |character|
          create(:posts_to_character, post: post, character: character)
        end
      end
    end
  end
end
