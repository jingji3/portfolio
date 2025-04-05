require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    crypted_password: Field::String,
    email: Field::String,
    role: Field::Select.with_options(searchable: false, collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys }),
    salt: Field::String,
    user_name: Field::String,
    password: Field::Password,
    password_confirmation: Field::Password,
    created_at: Field::DateTime.with_options(format: "%Y/%m/%d %H:%M"),
    updated_at: Field::DateTime.with_options(format: "%Y/%m/%d %H:%M"),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    user_name
    email
    role
    created_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    user_name
    email
    role
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    user_name
    email
    role
    password
    password_confirmation
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {
    # ユーザー名またはメールアドレスで検索
    search: ->(value) {
      { user_name_or_email_cont: value }
    },

    # 特定の権限を持つユーザーを検索
    role_eq: ->(value) {
      { role_eq: value }
    },

    # 登録日で検索
    created_after: ->(value) {
      { created_at_gteq: value.to_date }
    }
  }.freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
  def self.searchable_attributes
    %i[name email]
  end
end
