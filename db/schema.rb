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

ActiveRecord::Schema.define(version: 2023_05_01_144616) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abstinence_goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "current_goal"
    t.datetime "start_date"
    t.integer "length"
    t.boolean "achieved"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_abstinence_goals_on_user_id"
  end

  create_table "abstinence_trackers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "date"
    t.boolean "abstained"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_abstinence_trackers_on_user_id"
  end

  create_table "chats", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "habit_goals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "current_goal"
    t.text "input_text"
    t.datetime "start_date"
    t.integer "length"
    t.float "threshold"
    t.boolean "achieved"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_habit_goals_on_user_id"
  end

  create_table "habit_trackers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "date"
    t.boolean "habit_achieved"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_habit_trackers_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.datetime "date_time"
    t.boolean "prompt_or_response"
    t.bigint "chat_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "user_details", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "email"
    t.text "gender"
    t.integer "age"
    t.text "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_details_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "email", default: "", null: false
    t.text "encrypted_password", default: "", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "anonymous_id"
    t.text "question_1_answer"
    t.text "question_2_answer"
    t.text "question_3_answer"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "abstinence_goals", "users"
  add_foreign_key "abstinence_trackers", "users"
  add_foreign_key "chats", "users"
  add_foreign_key "habit_goals", "users"
  add_foreign_key "habit_trackers", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "users"
  add_foreign_key "user_details", "users"
end
