module CharacterSelect
  extend ActiveSupport::Concern

  private

  # キャラクター選択用メソッド（posts,teams,team_ratings共通）
  def set_characters_data
    @characters = Character.all.order(:name)

    # tom-selectでカナ、英語検索用のキャラクター名を取得
    @characters_json = @characters.map do |character|
      {
        id: character.id,
        name: character.name,
        name_kana: character.name_kana,
        name_eng: character.name_eng,
        searchable_name: "#{character.name} #{character.name_kana} #{character.name_eng}" # キャラクター検索ようにハッシュ化
      }
    end.to_json
  end
end
