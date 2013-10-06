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

ActiveRecord::Schema.define(version: 20131006144155) do

  create_table "addresses", force: true do |t|
    t.integer  "user_id"
    t.string   "to"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["to"], name: "index_addresses_on_to", unique: true
  add_index "addresses", ["token"], name: "index_addresses_on_token"

  create_table "aliases", force: true do |t|
    t.integer  "address_id"
    t.string   "to"
    t.string   "name",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "burnt",      default: false
  end

  add_index "aliases", ["to"], name: "index_aliases_on_to", unique: true

  create_table "postfix_aliases", id: false, force: true do |t|
    t.string "from"
    t.string "to"
  end

  add_index "postfix_aliases", ["from"], name: "index_postfix_aliases_on_from", unique: true

  create_table "users", force: true do |t|
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "account_type",           default: 0
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["address_id"], name: "index_users_on_address_id", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
