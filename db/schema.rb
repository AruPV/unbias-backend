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

ActiveRecord::Schema[7.2].define(version: 2024_08_28_143541) do
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

  create_table "article_versions", force: :cascade do |t|
    t.bigint "original_id"
    t.bigint "unbiased_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_id"
    t.index ["original_id"], name: "index_article_versions_on_original_id"
    t.index ["unbiased_id"], name: "index_article_versions_on_unbiased_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.integer "bias_score"
    t.integer "shock_score"
    t.string "top_biased_words", default: [], array: true
    t.bigint "article_version_id"
    t.string "user_id"
    t.index ["article_version_id"], name: "index_articles_on_article_version_id"
  end

  create_table "original_unbiaseds", force: :cascade do |t|
    t.bigint "original_id", null: false
    t.bigint "unbiased_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["original_id"], name: "index_original_unbiaseds_on_original_id"
    t.index ["unbiased_id"], name: "index_original_unbiaseds_on_unbiased_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "article_version_id", null: false
    t.boolean "is_like"
    t.string "user_id_clerk"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_version_id"], name: "index_votes_on_article_version_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "article_versions", "articles", column: "original_id"
  add_foreign_key "article_versions", "articles", column: "unbiased_id"
  add_foreign_key "articles", "article_versions"
  add_foreign_key "original_unbiaseds", "articles", column: "original_id"
  add_foreign_key "original_unbiaseds", "articles", column: "unbiased_id"
  add_foreign_key "votes", "article_versions"
end
