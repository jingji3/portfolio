class CharactersController < ApplicationController
  def show
    @character = Character.find(params[:id])

    respond_to do |format|
      format.html
      format.json {
        render json: {
          id: @character.id,
          name: @character.name,
          element: @character.element,
          star: @character.star,
          character_img: @character.character_img.attached? ?
                        url_for(@character.character_img) :
                        "/images/characters/default.png"
        }
       }
    end

  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to characters_path, alert: 'キャラクターが見つかりません' }
      format.json { render json: { error: 'キャラクターが見つかりません' }, status: :not_found }
    end
  end
end
