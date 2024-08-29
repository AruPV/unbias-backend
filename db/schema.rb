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

ActiveRecord::Schema[7.2].define(version: 2024_08_29_132834) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_versions", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.string "title"
    t.string "content"
    t.integer "bias_score"
    t.integer "shock_score"
    t.string "top_biased_words", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_article_versions_on_article_id"
  end

  create_table "articles", force: :cascade do |t|
    t.string "url"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "clerk_id"
    t.string "display_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "article_id", null: false
    t.boolean "is_like", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_votes_on_article_id"
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "article_versions", "articles"
  add_foreign_key "articles", "users"
  add_foreign_key "votes", "articles"
  add_foreign_key "votes", "users"
end
