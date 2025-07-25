class CharactersController < ApplicationController
  skip_before_action :require_login, only: %i[show]

  # キャラ選択時に必要なキャラクター情報を取得
  def show
    @character = Character.find(params[:id])

    respond_to do |format|
      format.html
      format.json do
        render json: {
          id: @character.id,
          name: @character.name,
          element: @character.element,
          star: @character.star,
          character_img: if @character.character_img.attached?
                           url_for(@character.character_img)
                         else
                           "/images/characters/default.png"
                         end
        }
      end
    end
  end
end
