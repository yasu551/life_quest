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

ActiveRecord::Schema[8.0].define(version: 2025_01_08_045439) do
  create_table "achievements", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: "", null: false
    t.text "memo", default: "", null: false
    t.integer "parent_id"
    t.integer "user_id", null: false
    t.date "achieved_on"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_achievements_on_parent_id"
    t.index ["user_id"], name: "index_achievements_on_user_id"
  end

  create_table "activities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "performed_at", null: false
    t.text "memo", default: "", null: false
    t.integer "task_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_activities_on_task_id"
  end

  create_table "activity_evaluations", force: :cascade do |t|
    t.string "value", default: "neutral", null: false
    t.text "reason", default: "", null: false
    t.integer "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_activity_evaluations_on_activity_id"
  end

  create_table "activity_summaries", force: :cascade do |t|
    t.date "start_on", null: false
    t.date "end_on", null: false
    t.text "content", default: "", null: false
    t.text "memo", default: "", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_activity_summaries_on_user_id"
  end

  create_table "activity_summary_items", force: :cascade do |t|
    t.integer "activity_summary_id", null: false
    t.integer "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_activity_summary_items_on_activity_id"
    t.index ["activity_summary_id", "activity_id"], name: "idx_on_activity_summary_id_activity_id_dd8c6dafdb", unique: true
  end

  create_table "challenges", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: "", null: false
    t.datetime "perform_at"
    t.datetime "performed_at"
    t.boolean "active", default: true, null: false
    t.string "source_type", null: false
    t.integer "source_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_type", "source_id"], name: "index_challenges_on_source"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address", null: false
    t.string "user_agent", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "color", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name"
    t.index ["user_id", "name"], name: "index_tags_on_user_id_and_name", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name", null: false
    t.text "completion_condition", default: "", null: false
    t.string "status", default: "new", null: false
    t.date "deadline_on"
    t.text "sub_tasks", default: "", null: false
    t.text "memo", default: "", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "time_entries", force: :cascade do |t|
    t.integer "task_id", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id", "created_at"], name: "index_time_entries_on_task_id_and_created_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "achievements", "achievements", column: "parent_id"
  add_foreign_key "achievements", "users"
  add_foreign_key "activities", "tasks"
  add_foreign_key "activity_evaluations", "activities"
  add_foreign_key "activity_summaries", "users"
  add_foreign_key "activity_summary_items", "activities"
  add_foreign_key "activity_summary_items", "activity_summaries"
  add_foreign_key "sessions", "users"
  add_foreign_key "tags", "users"
  add_foreign_key "tasks", "users"
  add_foreign_key "time_entries", "tasks"
end
