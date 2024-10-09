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

ActiveRecord::Schema[7.1].define(version: 2024_10_09_194206) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.boolean "operating_status"
    t.string "company_type"
    t.string "company_type_value"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_type_id"
    t.index ["company_name"], name: "index_companies_on_company_name", unique: true
    t.index ["linkedin_url"], name: "index_companies_on_linkedin_url", unique: true
  end

  create_table "company_types", force: :cascade do |t|
    t.string "key", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_company_types_on_key", unique: true
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
    t.index ["companies_id"], name: "index_job_posts_on_companies_id"
    t.index ["job_url"], name: "index_job_posts_on_job_url", unique: true
  end

  create_table "job_roles", force: :cascade do |t|
    t.string "role_name"
    t.string "role_department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_name"], name: "index_job_roles_on_role_name", unique: true
  end

  add_foreign_key "job_posts", "companies", column: "companies_id"
end
