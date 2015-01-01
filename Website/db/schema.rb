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

ActiveRecord::Schema.define(version: 20141230092611) do

  create_table "banned_ids", force: :cascade do |t|
    t.integer  "banned_id",  null: false
    t.datetime "deadline",   null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banned_ips", force: :cascade do |t|
    t.string   "banned_ip",  limit: 30, null: false
    t.datetime "deadline",              null: false
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "client_ips", force: :cascade do |t|
    t.string   "ip",         limit: 30, null: false
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "contest_problem_ships", force: :cascade do |t|
    t.integer  "contest_id"
    t.integer  "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contest_types", force: :cascade do |t|
    t.string   "name",        limit: 30,   null: false
    t.text     "description", limit: 1010, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "contests", force: :cascade do |t|
    t.string   "name",            limit: 60,                  null: false
    t.text     "description",     limit: 1010,                null: false
    t.datetime "start_time",                                  null: false
    t.datetime "end_time",                                    null: false
    t.boolean  "hide_problem",                 default: true, null: false
    t.integer  "contest_type_id"
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "course_problem_ships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name",                     null: false
    t.text     "description", limit: 1010, null: false
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "entries", force: :cascade do |t|
    t.string   "ip",         limit: 30, null: false
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "environment_types", force: :cascade do |t|
    t.string   "name",        limit: 30,   null: false
    t.text     "description", limit: 1010, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 20, null: false
    t.string   "origin_cmd", limit: 60, null: false
    t.string   "extra_cmd",  limit: 60
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string   "title",           limit: 60,                   null: false
    t.text     "body",            limit: 1010,                 null: false
    t.boolean  "read",                         default: false, null: false
    t.integer  "from_user_id",                                 null: false
    t.integer  "receive_user_id",                              null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "notices", force: :cascade do |t|
    t.string   "title",      limit: 30,    null: false
    t.text     "body",       limit: 10010, null: false
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "online_judges", force: :cascade do |t|
    t.string   "name",        limit: 30,   null: false
    t.text     "description", limit: 1010, null: false
    t.string   "address",     limit: 50,   null: false
    t.string   "regexp",      limit: 30,   null: false
    t.string   "hint",        limit: 30
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "operations", force: :cascade do |t|
    t.string   "ip",          limit: 30, null: false
    t.string   "description",            null: false
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "problem_types", force: :cascade do |t|
    t.string   "name",        limit: 30,   null: false
    t.text     "description", limit: 1010, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "problems", force: :cascade do |t|
    t.string   "name",            limit: 60,                 null: false
    t.integer  "environment",                default: 0,     null: false
    t.integer  "source_limit",               default: 0,     null: false
    t.integer  "time_limit",                 default: 0,     null: false
    t.integer  "memory_limit",               default: 0,     null: false
    t.string   "origin_id",       limit: 30, default: "0",   null: false
    t.boolean  "hide",                       default: false, null: false
    t.integer  "task",                       default: 0,     null: false
    t.integer  "user_id"
    t.integer  "online_judge_id"
    t.integer  "problem_type_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.integer  "solved_count",         default: 0, null: false
    t.integer  "accepted_count",       default: 0, null: false
    t.integer  "submissions_count",    default: 0, null: false
    t.integer  "statistic_table_id"
    t.string   "statistic_table_type"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name",       limit: 30, null: false
    t.string   "style"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "time",                           default: 0, null: false
    t.integer  "memory",                         default: 0, null: false
    t.string   "submit_ip",           limit: 30,             null: false
    t.integer  "score",                          default: 0, null: false
    t.integer  "source_length",                  default: 0, null: false
    t.integer  "submission_score",               default: 0, null: false
    t.integer  "task",                           default: 0, null: false
    t.integer  "user_id"
    t.integer  "statistic_id"
    t.integer  "language_id"
    t.integer  "status_id"
    t.integer  "environment_type_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "user_course_ships", force: :cascade do |t|
    t.integer  "status",     default: 1, null: false
    t.integer  "level",      default: 0, null: false
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",          limit: 30,              null: false
    t.string   "password",          limit: 40,              null: false
    t.string   "realname",          limit: 20
    t.string   "email",             limit: 110
    t.string   "create_ip",         limit: 30,              null: false
    t.string   "school"
    t.integer  "current_course_id",             default: 0, null: false
    t.integer  "solved_count",                  default: 0, null: false
    t.integer  "accepted_count",                default: 0, null: false
    t.integer  "submissions_count",             default: 0, null: false
    t.integer  "level",                         default: 0, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

end
