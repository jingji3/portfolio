require "administrate/base_dashboard"

class PostDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    body: Field::String,
    characters: CharacterImagesField,
    comments: Field::HasMany,
    favorites: Field::HasMany,
    likes: Field::HasMany,
    post_to_tags: Field::HasMany,
    posts_to_characters: Field::HasMany,
    tags: Field::HasMany,
    title: Field::String,
    user: Field::BelongsTo,
    video_url: Field::String,
    youtube_start_time: Field::Number,
    created_at: Field::Date,
    updated_at: Field::Date,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    title
    body
    characters
    user
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    title
    body
    user
    characters
    video_url
    youtube_start_time
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    body
    title
    video_url
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
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how posts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(post)
  #   "Post ##{post.id}"
  # end
end
