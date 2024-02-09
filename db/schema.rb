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

ActiveRecord::Schema[7.1].define(version: 2024_02_03_215400) do
  create_table "files", force: :cascade do |t|
    t.text "path", null: false
    t.integer "size", null: false
    t.string "digest", limit: 40, null: false
    t.date "created_at"
    t.text "kind"
  end

  create_table "media_files_restored_post_cards", id: false, force: :cascade do |t|
    t.integer "restored_post_card_id", null: false
    t.integer "media_file_id", null: false
    t.index ["media_file_id"], name: "index_media_files_restored_post_cards_on_media_file_id", unique: true
  end

  create_table "restored_post_cards", force: :cascade do |t|
    t.integer "index", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "restored_post_id"
    t.index ["restored_post_id", "index"], name: "index_restored_post_cards_on_restored_post_id_and_index", unique: true
    t.index ["restored_post_id"], name: "index_restored_post_cards_on_restored_post_id"
  end

  create_table "restored_posts", force: :cascade do |t|
    t.string "original_post_uuid", null: false
    t.text "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["original_post_uuid"], name: "index_restored_posts_on_original_post_uuid", unique: true
  end

  add_foreign_key "restored_post_cards", "restored_posts"
end
