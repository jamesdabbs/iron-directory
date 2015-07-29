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

ActiveRecord::Schema.define(version: 20150728234837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campuses", force: :cascade do |t|
    t.string   "name",       null: false
    t.json     "aliases"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "campuses", ["name"], name: "index_campuses_on_name", unique: true, using: :btree

  create_table "courses", force: :cascade do |t|
    t.integer "campus_id", null: false
    t.integer "topic_id",  null: false
    t.date    "start_on",  null: false
  end

  add_index "courses", ["campus_id"], name: "index_courses_on_campus_id", using: :btree
  add_index "courses", ["topic_id"], name: "index_courses_on_topic_id", using: :btree

  create_table "slack_teams", force: :cascade do |t|
    t.string   "slack_id"
    t.json     "slack_data"
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "slack_teams", ["slack_id"], name: "index_slack_teams_on_slack_id", unique: true, using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "title",      null: false
    t.json     "aliases"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "topics", ["title"], name: "index_topics_on_title", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: "",    null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.json     "google_auth"
    t.string   "api_key"
    t.boolean  "admin",               default: false, null: false
  end

  add_index "users", ["api_key"], name: "index_users_on_api_key", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "yardigans", force: :cascade do |t|
    t.integer  "slack_team_id"
    t.integer  "user_id"
    t.string   "slack_id"
    t.string   "slack_token"
    t.json     "slack_data"
    t.string   "email",            null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "campus_id"
    t.integer  "latest_course_id"
  end

  add_index "yardigans", ["campus_id"], name: "index_yardigans_on_campus_id", using: :btree
  add_index "yardigans", ["slack_id"], name: "index_yardigans_on_slack_id", using: :btree
  add_index "yardigans", ["user_id"], name: "index_yardigans_on_user_id", using: :btree

  add_foreign_key "courses", "campuses"
  add_foreign_key "courses", "topics"
  add_foreign_key "yardigans", "campuses"
  add_foreign_key "yardigans", "slack_teams"
  add_foreign_key "yardigans", "users"
end
