class CharactersController < ApplicationController
  skip_before_action :require_login, only: %i[show]

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
                           '/images/characters/default.png'
                         end
        }
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to characters_path, alert: 'キャラクターが見つかりません' }
      format.json { render json: { error: 'キャラクターが見つかりません' }, status: :not_found }
    end
  end
end
