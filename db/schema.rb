# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_04_02_111711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "makers", id: :serial, force: :cascade do |t|
    t.string "brand", null: false
    t.string "code"
    t.string "series"
    t.string "model"
    t.string "kind", null: false
    t.string "size"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_makers_on_code"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name"
    t.string "state"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "code"
    t.index ["code"], name: "index_merchants_on_code"
  end

  create_table "retailers", id: :serial, force: :cascade do |t|
    t.integer "maker_id"
    t.string "title", null: false
    t.float "price", null: false
    t.float "s_price"
    t.boolean "in_stock"
    t.text "description"
    t.string "picture_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shop", null: false
    t.string "link", null: false
    t.integer "duplicate", default: 0
    t.boolean "active", default: true
    t.string "code"
    t.index ["maker_id"], name: "index_retailers_on_maker_id"
  end

  add_foreign_key "retailers", "makers"
end
