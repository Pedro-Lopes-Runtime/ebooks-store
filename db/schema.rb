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

ActiveRecord::Schema[8.1].define(version: 2025_12_11_125320) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "buyers", force: :cascade do |t|
  end

  create_table "ebook_purchases", force: :cascade do |t|
    t.integer "ebook_id"
    t.float "price"
    t.integer "purchase_id"
    t.index ["ebook_id"], name: "index_ebook_purchases_on_ebook_id"
    t.index ["purchase_id"], name: "index_ebook_purchases_on_purchase_id"
  end

  create_table "ebook_statistics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "ebook_id"
    t.integer "preview_views", default: 0, null: false
    t.integer "purchases", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "visits", default: 0, null: false
    t.index ["ebook_id"], name: "index_ebook_statistics_on_ebook_id"
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
    t.float "price"
    t.integer "seller_id"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_ebooks_on_author_id"
    t.index ["ebook_status_id"], name: "index_ebooks_on_ebook_status_id"
    t.index ["seller_id"], name: "index_ebooks_on_seller_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "buyer_id"
    t.datetime "created_at", null: false
    t.integer "ebook_id"
    t.float "price", default: 0.0
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_purchases_on_buyer_id"
    t.index ["ebook_id"], name: "index_purchases_on_ebook_id"
  end

  create_table "sellers", force: :cascade do |t|
  end

  create_table "users", force: :cascade do |t|
    t.float "balance", default: 0.0
    t.datetime "created_at", null: false
    t.string "displayname"
    t.string "email"
    t.string "password_digest"
    t.integer "profileable_id"
    t.string "profileable_type"
    t.boolean "status"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["profileable_type", "profileable_id"], name: "index_users_on_profileable"
  end

  create_table "visitor_statistics", force: :cascade do |t|
    t.string "browser"
    t.datetime "created_at", null: false
    t.integer "ebook_statistic_id"
    t.string "ip"
    t.string "location"
    t.datetime "updated_at", null: false
    t.index ["ebook_statistic_id"], name: "index_visitor_statistics_on_ebook_statistic_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
