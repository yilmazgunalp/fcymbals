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

ActiveRecord::Schema.define(version: 20180110120822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "makers", force: :cascade do |t|
    t.string   "brand",       null: false
    t.string   "code"
    t.string   "series"
    t.string   "model"
    t.string   "kind",        null: false
    t.string   "size"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["code"], name: "index_makers_on_code", using: :btree
  end

  create_table "retailers", force: :cascade do |t|
    t.integer  "maker_id",    default: 3604
    t.string   "title",                      null: false
    t.float    "price",                      null: false
    t.float    "s_price"
    t.boolean  "in_stock"
    t.text     "description"
    t.string   "picture_url"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "merchant",                   null: false
    t.string   "link",                       null: false
    t.integer  "duplicate",   default: 0
    t.boolean  "active",      default: true
    t.string   "code"
    t.index ["maker_id"], name: "index_retailers_on_maker_id", using: :btree
  end

  add_foreign_key "retailers", "makers"
end
