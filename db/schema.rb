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

ActiveRecord::Schema[8.1].define(version: 2025_12_05_174516) do
  create_table "authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "buyers", force: :cascade do |t|
  end

  create_table "ebook_statuses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "ebooks", force: :cascade do |t|
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "ebook_status_id"
    t.integer "status_id"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_ebooks_on_author_id"
    t.index ["ebook_status_id"], name: "index_ebooks_on_ebook_status_id"
    t.index ["status_id"], name: "index_ebooks_on_status_id"
  end

  create_table "sellers", force: :cascade do |t|
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "displayname"
    t.string "email"
    t.integer "profileable_id"
    t.string "profileable_type"
    t.boolean "status"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["profileable_type", "profileable_id"], name: "index_users_on_profileable"
  end
end
