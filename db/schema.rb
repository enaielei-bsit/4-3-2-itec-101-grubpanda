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

ActiveRecord::Schema[7.0].define(version: 2022_06_17_073628) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "region"
    t.string "province"
    t.string "city"
    t.string "barangay"
    t.string "street"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "kiosks", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "mobile_number"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "address_id"
    t.index ["address_id"], name: "index_kiosks_on_address_id"
    t.index ["name"], name: "index_kiosks_on_name", unique: true
  end

  create_table "menu_items", force: :cascade do |t|
    t.bigint "menu_id"
    t.bigint "product_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id", "product_id"], name: "index_menu_items_on_menu_id_and_product_id", unique: true
    t.index ["menu_id"], name: "index_menu_items_on_menu_id"
    t.index ["product_id"], name: "index_menu_items_on_product_id"
  end

  create_table "menus", force: :cascade do |t|
    t.bigint "kiosk_id"
    t.string "name"
    t.integer "price"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kiosk_id", "name"], name: "index_menus_on_kiosk_id_and_name", unique: true
    t.index ["kiosk_id"], name: "index_menus_on_kiosk_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "address_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "value"], name: "index_permissions_on_user_id_and_value", unique: true
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "serving_size"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "menu_id"
    t.bigint "order_id"
    t.integer "price", default: 0
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["menu_id"], name: "index_purchases_on_menu_id"
    t.index ["order_id"], name: "index_purchases_on_order_id"
    t.index ["user_id", "menu_id"], name: "index_purchases_on_user_id_and_menu_id", unique: true
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "family_name"
    t.string "given_name"
    t.string "middle_name"
    t.string "password_digest"
    t.string "session_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "address_id"
    t.index ["address_id"], name: "index_users_on_address_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "kiosks", "addresses"
  add_foreign_key "menu_items", "menus"
  add_foreign_key "menu_items", "products"
  add_foreign_key "menus", "kiosks"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "users"
  add_foreign_key "permissions", "users"
  add_foreign_key "purchases", "menus"
  add_foreign_key "purchases", "orders"
  add_foreign_key "purchases", "users"
  add_foreign_key "users", "addresses"
end
