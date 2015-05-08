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

ActiveRecord::Schema.define(version: 20160505033406) do

  create_table "accesses", force: :cascade do |t|
    t.boolean  "is_root",            default: false, null: false
    t.boolean  "is_admin",           default: false, null: false
    t.boolean  "can_add_problem",    default: false, null: false
    t.boolean  "can_modify_problem", default: false, null: false
    t.boolean  "can_add_contest",    default: false, null: false
    t.boolean  "can_modify_contest", default: false, null: false
    t.boolean  "can_watch_code",     default: false, null: false
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "banned_ids", force: :cascade do |t|
    t.datetime "deadline",   null: false
    t.integer  "banned_id"
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

  create_table "blogs", force: :cascade do |t|
    t.string   "title",      limit: 60, null: false
    t.text     "body",                  null: false
    t.datetime "top"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "client_ips", force: :cascade do |t|
    t.string   "ip",         limit: 30, null: false
    t.datetime "last_login"
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "configs", force: :cascade do |t|
    t.string   "name",        limit: 50,                  null: false
    t.string   "value",       limit: 100
    t.string   "description", limit: 100,                 null: false
    t.boolean  "is_boolean",              default: true,  null: false
    t.boolean  "is_integer",              default: false, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "contest_problem_ships", force: :cascade do |t|
    t.integer  "contest_id"
    t.integer  "problem_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contest_types", force: :cascade do |t|
    t.string   "name",        limit: 30,  null: false
    t.string   "description", limit: 210, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "contests", force: :cascade do |t|
    t.string   "name",            limit: 60, null: false
    t.datetime "start_time",                 null: false
    t.datetime "end_time",                   null: false
    t.boolean  "hide_problem",               null: false
    t.integer  "contest_type_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "entries", force: :cascade do |t|
    t.string   "ip",         limit: 30, null: false
    t.integer  "user_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "language_problem_type_ships", force: :cascade do |t|
    t.integer  "language_id"
    t.integer  "problem_type_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 20,  null: false
    t.string   "cmd",        limit: 100, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text     "message",                     null: false
    t.boolean  "read",        default: false, null: false
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "online_judges", force: :cascade do |t|
    t.string   "name",        limit: 30,  null: false
    t.string   "description", limit: 210
    t.string   "address",     limit: 50,  null: false
    t.string   "regexp",      limit: 30,  null: false
    t.string   "hint",        limit: 50
    t.string   "default",     limit: 50,  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "operations", force: :cascade do |t|
    t.string   "ip",          limit: 30,  null: false
    t.string   "description", limit: 110, null: false
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "page_number_counters", force: :cascade do |t|
    t.string   "path",       limit: 50,             null: false
    t.integer  "times",                 default: 0, null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  create_table "problem_types", force: :cascade do |t|
    t.string   "name",        limit: 30,  null: false
    t.string   "description", limit: 210, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "problems", force: :cascade do |t|
    t.string   "name",            limit: 60,                 null: false
    t.integer  "answer_limit",               default: 0,     null: false
    t.integer  "time_limit",                 default: 0,     null: false
    t.integer  "memory_limit",               default: 0,     null: false
    t.integer  "test_count",                 default: 10,    null: false
    t.string   "origin_id",       limit: 30, default: "0",   null: false
    t.boolean  "hide",                       default: false, null: false
    t.boolean  "submit",                     default: false, null: false
    t.boolean  "task",                       default: false, null: false
    t.integer  "user_id"
    t.integer  "online_judge_id"
    t.integer  "problem_type_id"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.integer  "solved_count",       default: 0, null: false
    t.integer  "accepted_count",     default: 0, null: false
    t.integer  "submissions_count",  default: 0, null: false
    t.integer  "statisticable_id"
    t.string   "statisticable_type"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name",       limit: 30, null: false
    t.string   "style",      limit: 30
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "time",                        default: 0, null: false
    t.integer  "memory",                      default: 0, null: false
    t.string   "submit_ip",        limit: 30,             null: false
    t.integer  "score",                       default: 0, null: false
    t.integer  "code_length",                 default: 0, null: false
    t.integer  "submission_score",            default: 0, null: false
    t.integer  "task",                        default: 0, null: false
    t.integer  "user_id"
    t.integer  "statistic_id"
    t.integer  "language_id"
    t.integer  "status_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",          limit: 30,              null: false
    t.string   "password",          limit: 40,              null: false
    t.string   "nickname",          limit: 30
    t.string   "sign",              limit: 110
    t.string   "create_ip",         limit: 30,              null: false
    t.datetime "last_online"
    t.integer  "solved_count",                  default: 0, null: false
    t.integer  "accepted_count",                default: 0, null: false
    t.integer  "submissions_count",             default: 0, null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

end
