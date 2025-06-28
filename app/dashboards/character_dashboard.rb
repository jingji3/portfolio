require "administrate/base_dashboard"
require Rails.root.join("app/fields/image_field")

class CharacterDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    character_img: ImageField,
    element: EnumField,
    name: Field::String,
    name_eng: Field::String,
    name_kana: Field::String,
    star: Field::Number,
    version: Field::String,
    version_half: EnumField,
    created_at: Field::Date,
    updated_at: Field::Date
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    character_img
    name
    element
    star
    version
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    character_img
    element
    name
    name_eng
    name_kana
    star
    version
    version_half
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    character_img
    element
    name
    name_eng
    name_kana
    star
    version
    version_half
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
    # キャラクター名（日本語/英語/かな）で検索
    search: lambda { |value|
      { name_or_name_kana_or_name_eng_cont: value }
    },

    # 元素で検索
    element_eq: lambda { |value|
      { element_eq: value }
    },

    # レアリティで検索
    star_eq: lambda { |value|
      { star_eq: value.to_i }
    }
  }.freeze

  # Overwrite this method to customize how characters are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(character)
  #   "Character ##{character.id}"
  # end

  def display_resource(character)
    "キャラID:#{character.id}"
  end
end
