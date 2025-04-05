module Admin
  class CharactersController < Admin::ApplicationController
    include AdministrateRansackSearch

    def resource_params
      super.tap do |params|
        params.permit(:character_img) if params[:character_img].present?
      end
    end
  end
end
