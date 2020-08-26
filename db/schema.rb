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

ActiveRecord::Schema.define(version: 20190818232049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"

  create_table "charges", force: :cascade do |t|
    t.integer  "shop_id"
    t.string   "uid",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "activated_at"
  end

  add_index "charges", ["shop_id"], name: "index_charges_on_shop_id", using: :btree

  create_table "competitions", force: :cascade do |t|
    t.integer  "instructor_id"
    t.string   "name",          limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "welcome_note"
    t.string   "token",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "message"
    t.boolean  "is_seeded",                 default: false
  end

  add_index "competitions", ["instructor_id"], name: "index_competitions_on_instructor_id", using: :btree
  add_index "competitions", ["token"], name: "index_competitions_on_token", unique: true, using: :btree

  create_table "coupon_redemptions", force: :cascade do |t|
    t.integer  "coupon_id",  null: false
    t.string   "user_id"
    t.string   "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "code",                                    null: false
    t.string   "description"
    t.date     "valid_from",                              null: false
    t.date     "valid_until"
    t.integer  "redemption_limit",         default: 1,    null: false
    t.integer  "coupon_redemptions_count", default: 0,    null: false
    t.integer  "amount",                   default: 0,    null: false
    t.string   "type",                                    null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.text     "attachments",              default: "{}", null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "shop_id"
    t.string   "uid",         limit: 255
    t.string   "email",       limit: 255
    t.datetime "acquired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["shop_id"], name: "index_customers_on_shop_id", using: :btree
  add_index "customers", ["uid"], name: "index_customers_on_uid", unique: true, using: :btree

  create_table "expenses", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name",       limit: 255
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "expenses", ["team_id"], name: "index_expenses_on_team_id", using: :btree

  create_table "instructors", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "phone",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "linkedin_uid",    limit: 255
    t.string   "linkedin_token",  limit: 255
    t.string   "avatar_url",      limit: 255
    t.boolean  "is_seeded",                   default: false
    t.string   "password_digest", limit: 255
  end

  add_index "instructors", ["linkedin_uid"], name: "index_instructors_on_linkedin_uid", unique: true, using: :btree

  create_table "learning_resource_questions", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.integer  "order",                            default: 0
    t.integer  "learning_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "learning_resource_questions", ["learning_resource_id"], name: "index_learning_resource_questions_on_learning_resource_id", using: :btree

  create_table "learning_resource_tasks", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.integer  "order",                            default: 0
    t.integer  "learning_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "learning_resource_tasks", ["learning_resource_id"], name: "index_learning_resource_tasks_on_learning_resource_id", using: :btree

  create_table "learning_resources", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "body"
    t.string   "video_url",     limit: 255
    t.integer  "instructor_id"
    t.integer  "order",                     default: 0
    t.boolean  "is_template",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_published",              default: false
    t.text     "description"
    t.boolean  "is_deleted",                default: false
  end

  add_index "learning_resources", ["instructor_id"], name: "index_learning_resources_on_instructor_id", using: :btree

  create_table "line_items", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "uid",         limit: 255
    t.float    "price"
    t.integer  "quantity"
    t.string   "product_uid", limit: 255
    t.string   "sku",         limit: 255
    t.string   "title",       limit: 255
    t.string   "name",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "shop_id"
    t.string   "uid",              limit: 255
    t.datetime "placed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "subtotal_price",               precision: 8, scale: 2
    t.decimal  "total_tax",                    precision: 8, scale: 2
    t.decimal  "total_discounts",              precision: 8, scale: 2
    t.decimal  "total_price",                  precision: 8, scale: 2
    t.string   "customer_uid",     limit: 255
    t.string   "financial_status",                                     default: "paid"
  end

  add_index "orders", ["shop_id"], name: "index_orders_on_shop_id", using: :btree
  add_index "orders", ["uid"], name: "index_orders_on_uid", unique: true, using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "shop_id"
    t.string   "uid",           limit: 255
    t.string   "name",          limit: 255
    t.integer  "quantity"
    t.float    "total_revenue"
    t.float    "unit_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["shop_id"], name: "index_products_on_shop_id", using: :btree

  create_table "referrals", force: :cascade do |t|
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
  end

  add_index "referrals", ["order_id"], name: "index_referrals_on_order_id", using: :btree

  create_table "shop_requests", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name",             limit: 255
    t.string   "url",              limit: 255
    t.string   "shopify_uid",      limit: 255
    t.string   "shopify_token",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "confirmation_url"
    t.boolean  "is_pending",                   default: true
  end

  add_index "shop_requests", ["team_id"], name: "index_shop_requests_on_team_id", using: :btree

  create_table "shops", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name",                     limit: 255
    t.string   "url",                      limit: 255
    t.datetime "webhooks_last_checked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shopify_uid",              limit: 255
    t.string   "shopify_token",            limit: 255
  end

  add_index "shops", ["shopify_uid"], name: "index_shops_on_shopify_uid", unique: true, using: :btree
  add_index "shops", ["team_id"], name: "index_shops_on_team_id", using: :btree
  add_index "shops", ["url"], name: "index_shops_on_url", unique: true, using: :btree

  create_table "students", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "team_id"
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "phone",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "linkedin_uid",    limit: 255
    t.text     "linkedin_token"
    t.string   "avatar_url",      limit: 255
    t.string   "password_digest", limit: 255
  end

  add_index "students", ["competition_id"], name: "index_students_on_competition_id", using: :btree
  add_index "students", ["linkedin_uid"], name: "index_students_on_linkedin_uid", unique: true, using: :btree
  add_index "students", ["team_id"], name: "index_students_on_team_id", using: :btree

  create_table "task_completions", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "team_id"
    t.hstore   "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_completions", ["task_id"], name: "index_task_completions_on_task_id", using: :btree
  add_index "task_completions", ["team_id"], name: "index_task_completions_on_team_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "description"
    t.integer  "points"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",          limit: 255
    t.boolean  "requires_shop",             default: false
    t.integer  "team_id"
    t.text     "response"
    t.datetime "completed_at"
  end

  add_index "tasks", ["team_id"], name: "index_tasks_on_team_id", using: :btree

  create_table "team_comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "creator_id"
    t.string   "creator_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "team_id"
  end

  add_index "team_comments", ["team_id"], name: "index_team_comments_on_team_id", using: :btree

  create_table "team_learning_resource_answers", force: :cascade do |t|
    t.text     "body"
    t.integer  "student_id"
    t.integer  "question_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "team_learning_resource_answers", ["student_id"], name: "index_team_learning_resource_answers_on_student_id", using: :btree

  create_table "team_learning_resource_questions", force: :cascade do |t|
    t.string   "title",                     limit: 255
    t.integer  "order",                                 default: 0
    t.integer  "team_learning_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_learning_resource_tasks", force: :cascade do |t|
    t.string   "title",                     limit: 255
    t.integer  "order",                                 default: 0
    t.boolean  "is_complete"
    t.integer  "team_learning_resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_learning_resources", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "order",                  default: 0
    t.string   "title",      limit: 255
    t.text     "body"
    t.string   "video_url",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "task_id"
  end

  add_index "team_learning_resources", ["task_id"], name: "index_team_learning_resources_on_task_id", using: :btree
  add_index "team_learning_resources", ["team_id"], name: "index_team_learning_resources_on_team_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "competition_id"
    t.string   "name",                limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "color",               limit: 255
    t.integer  "cached_total_points",             default: 0
    t.string   "coupon_code"
  end

  add_index "teams", ["competition_id"], name: "index_teams_on_competition_id", using: :btree

  add_foreign_key "team_comments", "teams"
end
