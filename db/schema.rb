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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 2022_01_08_110858) do
=======
ActiveRecord::Schema.define(version: 2022_01_08_061402) do
>>>>>>> 00297de25196a8e3fa55ed1d01f0865b61b92d02

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "choices", force: :cascade do |t|
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.string "location"
    t.bigint "meeting_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["meeting_id"], name: "index_choices_on_meeting_id"
  end

  create_table "meeting_non_users", force: :cascade do |t|
    t.bigint "meeting_id"
    t.string "non_user_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["meeting_id"], name: "index_meeting_non_users_on_meeting_id"
  end

  create_table "meeting_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "meeting_id"
    t.boolean "host", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["meeting_id"], name: "index_meeting_users_on_meeting_id"
    t.index ["user_id"], name: "index_meeting_users_on_user_id"
  end

  create_table "meetings", force: :cascade do |t|
    t.string "invitee_email"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.string "location"
    t.string "meeting_link"
    t.string "status"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_meetings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.integer "expires_at"
    t.boolean "expires"
    t.string "refresh_token"
    t.string "image"
    t.string "about"
    t.text "description"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "meeting_non_users", "meetings"
  add_foreign_key "meeting_users", "meetings"
  add_foreign_key "meeting_users", "users"
end
