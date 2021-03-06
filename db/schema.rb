# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_23_073937) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "statements", force: :cascade do |t|
    t.string "title"
    t.datetime "period"
    t.text "memo"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_statements_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "trans_type"
    t.datetime "trans_date"
    t.string "category"
    t.text "description"
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "statement_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["statement_id"], name: "index_transactions_on_statement_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.decimal "balance", precision: 10, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "statements", "users"
  add_foreign_key "transactions", "statements"
  add_foreign_key "transactions", "users"
end
