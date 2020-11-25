# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_03_060501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "characters", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "characters_games", id: false, force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "character_id", null: false
    t.index ["character_id", "game_id"], name: "index_characters_games_on_character_id_and_game_id"
    t.index ["game_id", "character_id"], name: "index_characters_games_on_game_id_and_character_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "difficulty"
    t.text "state"
    t.text "ten_quote_ids"
    t.boolean "completed"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.text "content"
    t.string "source"
    t.bigint "character_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_quotes_on_character_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.boolean "email_confirmed"
    t.string "email_confirmation_token"
    t.datetime "email_confirmation_sent_at"
    t.datetime "email_confirmation_confirmed_at"
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "password_reset_confirmed_at"
    t.datetime "last_successful_login"
    t.datetime "last_failed_login_attempt"
    t.integer "failed_login_attempts", default: 0
    t.boolean "authentication_lockout", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "games", "users"
  add_foreign_key "quotes", "characters"
end
