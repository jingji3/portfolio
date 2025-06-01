# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_06_01_072730) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authentications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name", null: false
    t.string "name_kana", null: false
    t.string "name_eng", null: false
    t.integer "element", null: false
    t.integer "star", null: false
    t.string "version"
    t.integer "version_half"
    t.string "character_img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comment_likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "comment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "post_id", null: false
    t.string "comment", null: false
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_comments_on_parent_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "post_to_tags", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id", "tag_id"], name: "index_post_to_tags_on_post_id_and_tag_id", unique: true
    t.index ["post_id"], name: "index_post_to_tags_on_post_id"
    t.index ["tag_id"], name: "index_post_to_tags_on_tag_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.string "body", null: false
    t.string "video_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "youtube_start_time"
    t.index ["title"], name: "index_posts_on_title"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "posts_to_characters", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "character_id", null: false
    t.integer "constellation", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_posts_to_characters_on_character_id"
    t.index ["post_id"], name: "index_posts_to_characters_on_post_id"
  end

  create_table "request_to_characters", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_request_to_characters_on_character_id"
    t.index ["request_id", "character_id"], name: "index_request_to_characters_on_request_id_and_character_id", unique: true
    t.index ["request_id"], name: "index_request_to_characters_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "message", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "team_ratings", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.string "body"
    t.decimal "rating", precision: 3, scale: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id", "user_id"], name: "index_team_ratings_on_team_id_and_user_id", unique: true
    t.index ["team_id"], name: "index_team_ratings_on_team_id"
    t.index ["user_id"], name: "index_team_ratings_on_user_id"
  end

  create_table "team_to_characters", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_team_to_characters_on_character_id"
    t.index ["team_id", "character_id"], name: "index_team_to_characters_on_team_id_and_character_id", unique: true
    t.index ["team_id"], name: "index_team_to_characters_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "user_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "post_to_tags", "posts"
  add_foreign_key "post_to_tags", "tags"
  add_foreign_key "posts", "users"
  add_foreign_key "posts_to_characters", "characters"
  add_foreign_key "posts_to_characters", "posts"
  add_foreign_key "request_to_characters", "characters"
  add_foreign_key "request_to_characters", "requests"
  add_foreign_key "requests", "users"
  add_foreign_key "team_ratings", "teams"
  add_foreign_key "team_ratings", "users"
  add_foreign_key "team_to_characters", "characters"
  add_foreign_key "team_to_characters", "teams"
end
