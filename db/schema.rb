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

ActiveRecord::Schema.define(version: 20170528200312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "analyses", force: :cascade do |t|
    t.integer "repository_id"
    t.jsonb "payload", null: false
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.string "event"
    t.index ["payload"], name: "index_analyses_on_payload", using: :gin
    t.index ["repository_id"], name: "index_analyses_on_repository_id"
  end

  create_table "repositories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "account_id"
    t.integer "hook_id"
    t.bigint "github_id", null: false
    t.boolean "active", default: true, null: false
    t.index ["account_id"], name: "index_repositories_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "github_username", null: false
    t.string "github_token", null: false
    t.string "github_token_scopes", null: false
    t.string "remember_token", null: false
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "repositories", "accounts"
end
