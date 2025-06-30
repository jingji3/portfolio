FactoryBot.define do
  factory :team do
    name { "テストチーム" }
    body { "テスト内容" }

    trait :with_characters do
      after (:create) do |team|
        characters = create_list(:character, 4)
        characters.each do |character|
          create(:posts_to_character, post: team, character: character)
        end
      end
    end
  end
end
