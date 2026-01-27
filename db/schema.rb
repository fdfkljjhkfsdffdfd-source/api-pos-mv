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

ActiveRecord::Schema[7.0].define(version: 2025_12_19_073143) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auths", force: :cascade do |t|
    t.string "login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "sku_master_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["sku_master_id"], name: "index_cart_items_on_sku_master_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.decimal "total_summary"
    t.integer "total_amount"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "receipt_items", force: :cascade do |t|
    t.bigint "receipt_id", null: false
    t.bigint "sku_master_id", null: false
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receipt_id"], name: "index_receipt_items_on_receipt_id"
    t.index ["sku_master_id"], name: "index_receipt_items_on_sku_master_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "receipt_no"
    t.decimal "total_summary"
    t.integer "total_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_receipts_on_user_id"
  end

  create_table "sku_masters", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id", null: false
    t.integer "amount"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_sku_masters_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "cart_items", "carts", on_delete: :cascade
  add_foreign_key "cart_items", "sku_masters"
  add_foreign_key "carts", "users", on_delete: :cascade
  add_foreign_key "receipt_items", "receipts", on_delete: :cascade
  add_foreign_key "receipt_items", "sku_masters"
  add_foreign_key "receipts", "users", on_delete: :cascade
  add_foreign_key "sku_masters", "categories"
end
