module AdministrateRansackSearch
  extend ActiveSupport::Concern

  included do
    def scoped_resource
      if params[:q].present?
        resource_class.ransack(params[:q]).result(distinct: true)
      else
        resource_class.all
      end
    end

    def apply_resource_includes(resource)
      if resource.respond_to?(:ransack)
        resource
      else
        super
      end
    end
  end
end
