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

ActiveRecord::Schema.define(version: 20170321020050) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adverts", force: :cascade do |t|
    t.text     "title"
    t.text     "image_url"
    t.text     "advert_body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "announcements", force: :cascade do |t|
    t.text     "content",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "money_requests", force: :cascade do |t|
    t.integer  "user_id",                                                   null: false
    t.text     "type"
    t.decimal  "amount",           precision: 17, scale: 4
    t.decimal  "balance",          precision: 17, scale: 4
    t.integer  "status",                                    default: 1,     null: false
    t.date     "maturity_date"
    t.boolean  "matured"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.boolean  "compounded",                                default: false
    t.datetime "profit_from_date"
  end

  create_table "money_transactions", force: :cascade do |t|
    t.integer  "withdrawal_id",                                         null: false
    t.integer  "donation_id",                                           null: false
    t.integer  "status",                                    default: 1, null: false
    t.decimal  "amount",           precision: 17, scale: 4
    t.text     "proof_of_payment"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
  end

  create_table "payment_accounts", force: :cascade do |t|
    t.integer  "user_id",             null: false
    t.text     "bank_name"
    t.text     "account_number"
    t.text     "branch_code"
    t.text     "account_type"
    t.text     "account_holder_name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "referrals", force: :cascade do |t|
    t.integer  "referrer_id",                                             null: false
    t.integer  "referee_id",                                              null: false
    t.boolean  "bonus_paid_out",                          default: false, null: false
    t.decimal  "bonus_amount",   precision: 17, scale: 4
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.string   "cellphone"
    t.integer  "roles_mask"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "guid",                                null: false
    t.text     "referer_guid"
    t.text     "referrer_email"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
