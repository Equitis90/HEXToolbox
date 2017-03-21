# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170303145019) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "deck_cards", force: :cascade do |t|
    t.integer  "amount",                     null: false
    t.integer  "card_id",                    null: false
    t.integer  "deck_id",                    null: false
    t.boolean  "reserve",    default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "deck_cards", ["deck_id"], name: "index_deck_cards_on_deck_id", using: :btree

  create_table "deck_gems", force: :cascade do |t|
    t.integer  "card_id",    null: false
    t.integer  "gem_id",     null: false
    t.integer  "deck_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "deck_gems", ["deck_id"], name: "index_deck_gems_on_deck_id", using: :btree

  create_table "decks", force: :cascade do |t|
    t.date     "date"
    t.string   "ign"
    t.string   "tournament_id"
    t.string   "type"
    t.string   "name"
    t.integer  "points_won"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "champion_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "game_objects", force: :cascade do |t|
    t.integer  "atk",                                           null: false
    t.integer  "cost"
    t.string   "name",                                          null: false
    t.text     "text",                                          null: false
    t.text     "object_type",                                   null: false
    t.string   "uuid",                                          null: false
    t.text     "color",                                         null: false
    t.string   "artist",                                        null: false
    t.integer  "health",                                        null: false
    t.string   "rarity",                                        null: false
    t.string   "sub_type",                                      null: false
    t.text     "threshold",                                     null: false
    t.text     "set_number",                                    null: false
    t.text     "equipment_uuids",                               null: false
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "file_name",       default: "DefaultSleeve.png", null: false
  end

  create_table "processed_files", force: :cascade do |t|
    t.string   "file_name",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "deck_cards", "decks"
  add_foreign_key "deck_gems", "decks"
end
