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

ActiveRecord::Schema.define(version: 20160303112938) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "unaccent"
  enable_extension "pg_trgm"

  create_table "activities_declarations", force: :cascade do |t|
    t.integer "person_id"
    t.date    "declaration_date"
    t.json    "data"
  end

  create_table "administrators", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
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
  end

  add_index "administrators", ["email"], name: "index_administrators_on_email", unique: true, using: :btree
  add_index "administrators", ["reset_password_token"], name: "index_administrators_on_reset_password_token", unique: true, using: :btree

  create_table "areas", force: :cascade do |t|
    t.string "name"
  end

  create_table "assets_declarations", force: :cascade do |t|
    t.integer "person_id"
    t.date    "declaration_date"
    t.json    "data"
  end

  create_table "contracts", force: :cascade do |t|
    t.string   "center"
    t.string   "organism"
    t.string   "contract_number"
    t.string   "document_number"
    t.text     "description"
    t.string   "kind"
    t.string   "award_procedure"
    t.string   "article"
    t.string   "article_section"
    t.string   "award_criteria"
    t.integer  "budget_amount_cents"
    t.integer  "award_amount_cents"
    t.string   "term"
    t.date     "awarded_at"
    t.string   "recipient"
    t.string   "recipient_document_number"
    t.date     "formalized_at"
    t.boolean  "framework_agreement"
    t.boolean  "zero_cost_revenue"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string  "name"
    t.text    "description"
    t.text    "directives"
    t.integer "area_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.string  "title"
    t.text    "description"
    t.boolean "accomplished",  default: false
    t.integer "order"
    t.integer "department_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "content"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
  end

  add_index "pages", ["ancestry"], name: "index_pages_on_ancestry", using: :btree

  create_table "parties", force: :cascade do |t|
    t.string "name"
    t.string "logo"
    t.string "long_name"
  end

  create_table "people", force: :cascade do |t|
    t.integer  "party_id"
    t.string   "name"
    t.string   "email"
    t.string   "role"
    t.text     "functions"
    t.string   "diary"
    t.integer  "councillor_code"
    t.string   "slug"
    t.json     "profile"
    t.string   "twitter"
    t.string   "facebook"
    t.integer  "personal_code"
    t.datetime "profiled_at"
    t.string   "unit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "area"
    t.string   "district"
    t.string   "job_level"
  end

  add_index "people", ["area"], name: "index_people_on_area", using: :btree
  add_index "people", ["job_level"], name: "index_people_on_job_level", using: :btree
  add_index "people", ["name"], name: "index_people_on_name", using: :btree
  add_index "people", ["party_id"], name: "index_people_on_party_id", using: :btree
  add_index "people", ["slug"], name: "index_people_on_slug", unique: true, using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "subventions", force: :cascade do |t|
    t.string   "recipient",    null: false
    t.string   "project"
    t.string   "kind"
    t.string   "location"
    t.integer  "year"
    t.integer  "amount_cents", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "subventions", ["recipient"], name: "index_subventions_on_recipient", using: :btree

end
