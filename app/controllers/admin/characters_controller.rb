module Admin
  class CharactersController < Admin::ApplicationController
    include AdministrateRansackSearch

    layout "admin"

    def create
      resource = resource_class.new(resource_params)

      if resource.save
        redirect_to(
          [namespace, resource_class],  # ここを変更: [namespace, resource] から [namespace, resource_class] に
          notice: translate_with_resource("create.success"),
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
        }, status: :unprocessable_entity
      end
    end

    def resource_params
      super.tap do |params|
        params.permit(:character_img) if params[:character_img].present?
      end
    end
  end
end
