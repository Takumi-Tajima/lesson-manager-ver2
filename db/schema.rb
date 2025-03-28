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

ActiveRecord::Schema[8.0].define(version: 2025_03_24_131805) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "instructors", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_instructors_on_email", unique: true
  end

  create_table "lesson_dates", force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.integer "capacity", default: 1, null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reservations_count", default: 0, null: false
    t.index ["lesson_id"], name: "index_lesson_dates_on_lesson_id"
  end

  create_table "lesson_question_answers", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.string "question"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservation_id"], name: "index_lesson_question_answers_on_reservation_id"
  end

  create_table "lesson_questions", force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_questions_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "instructor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.index ["instructor_id"], name: "index_lessons_on_instructor_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "lesson_date_id", null: false
    t.bigint "user_id", null: false
    t.string "lesson_name", null: false
    t.string "instructor_name", null: false
    t.text "lesson_description", null: false
    t.datetime "start_at", null: false
    t.datetime "end_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url", default: "", null: false
    t.index ["lesson_date_id", "user_id"], name: "index_reservations_on_lesson_date_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "lesson_dates", "lessons"
  add_foreign_key "lesson_question_answers", "reservations"
  add_foreign_key "lesson_questions", "lessons"
  add_foreign_key "lessons", "instructors"
  add_foreign_key "reservations", "lesson_dates"
  add_foreign_key "reservations", "users"
end
