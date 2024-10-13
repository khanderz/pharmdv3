# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_13_181747) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.boolean "operating_status"
    t.string "company_ats_type"
    t.string "company_size"
    t.string "last_funding_type"
    t.string "linkedin_url"
    t.boolean "is_public"
    t.integer "year_founded"
    t.string "company_city"
    t.string "company_state"
    t.string "company_country"
    t.string "acquired_by"
    t.string "ats_id"
    t.text "company_description"
    t.bigint "company_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_name"], name: "index_companies_on_company_name", unique: true
    t.index ["company_type_id"], name: "index_companies_on_company_type_id"
    t.index ["linkedin_url"], name: "index_companies_on_linkedin_url", unique: true
  end

  create_table "company_specializations", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "company_specialty_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_specializations_on_company_id"
    t.index ["company_specialty_id"], name: "index_company_specializations_on_company_specialty_id"
  end

  create_table "company_specialties", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.bigint "company_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_type_id"], name: "index_company_specialties_on_company_type_id"
  end

  create_table "company_types", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_posts", force: :cascade do |t|
    t.bigint "companies_id", null: false
    t.string "job_title"
    t.text "job_description"
    t.string "job_url"
    t.string "job_location"
    t.string "job_dept"
    t.datetime "job_posted"
    t.datetime "job_updated"
    t.boolean "job_active"
    t.bigint "job_internal_id"
    t.bigint "job_url_id"
    t.string "job_internal_id_string"
    t.integer "job_salary_min"
    t.integer "job_salary_max"
    t.string "job_salary_range"
    t.string "job_country"
    t.string "job_setting"
    t.text "job_additional"
    t.string "job_commitment"
    t.string "job_team"
    t.string "job_allLocations"
    t.text "job_responsibilities"
    t.text "job_qualifications"
    t.text "job_applyUrl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "job_role_id", null: false
    t.index ["companies_id"], name: "index_job_posts_on_companies_id"
    t.index ["job_active"], name: "index_job_posts_on_job_active"
    t.index ["job_role_id"], name: "index_job_posts_on_job_role_id"
    t.index ["job_url"], name: "index_job_posts_on_job_url", unique: true
  end

  create_table "job_roles", force: :cascade do |t|
    t.string "role_name"
    t.string "role_department"
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_name"], name: "index_job_roles_on_role_name", unique: true
  end

  add_foreign_key "companies", "company_types"
  add_foreign_key "company_specializations", "companies"
  add_foreign_key "company_specializations", "company_specialties"
  add_foreign_key "company_specialties", "company_types"
  add_foreign_key "job_posts", "companies", column: "companies_id"
  add_foreign_key "job_posts", "job_roles"
end
