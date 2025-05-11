class CharacterImageCompressJob < ApplicationJob
  queue_as :default

  def perform(character_id)
    character = Character.find_by(id: character_id)
    return unless character&.character_img&.attached?

    # 少し待つことでファイルシステムとの同期を確保
    sleep 2

    # 既存の圧縮メソッドを呼び出し
    character.send(:compress_image)
  end
end
