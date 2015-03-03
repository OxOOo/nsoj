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

ActiveRecord::Schema.define(version: 20150301132300) do

  create_table "languages", force: :cascade do |t|
    t.string   "title",      limit: 35, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "problem_type_language_ships", force: :cascade do |t|
    t.integer  "problem_type_id"
    t.integer  "language_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "problem_types", force: :cascade do |t|
    t.string   "title",      limit: 55, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "problems", force: :cascade do |t|
    t.integer  "problem_type_id"
    t.string   "title",           limit: 55,                 null: false
    t.integer  "time_limit",                 default: 0,     null: false
    t.integer  "memory_limit",               default: 0,     null: false
    t.integer  "submit_limit",               default: 0,     null: false
    t.integer  "test_count",                 default: 10,    null: false
    t.boolean  "show",                       default: false, null: false
    t.boolean  "judge",                      default: false, null: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.integer  "problem_id"
    t.integer  "user_id"
    t.integer  "language_id"
    t.integer  "score",       default: 0,     null: false
    t.integer  "time",        default: 0,     null: false
    t.integer  "memory",      default: 0,     null: false
    t.integer  "size",        default: 0,     null: false
    t.boolean  "task",        default: false, null: false
    t.boolean  "finish",      default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   limit: 35,                 null: false
    t.string   "password",   limit: 35,                 null: false
    t.boolean  "admin",                 default: false, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

end
