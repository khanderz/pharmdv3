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

ActiveRecord::Schema[7.1].define(version: 2024_10_18_195457) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adjudications", force: :cascade do |t|
    t.string "adjudicatable_type"
    t.bigint "adjudicatable_id"
    t.text "error_details"
    t.boolean "resolved", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adjudicatable_type", "adjudicatable_id"], name: "index_adjudications_on_adjudicatable"
  end

  create_table "ats_types", force: :cascade do |t|
    t.string "ats_type_code"
    t.string "ats_type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ats_type_code"], name: "index_ats_types_on_ats_type_code", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.string "city_name"
    t.string "aliases", default: [], array: true
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_name"], name: "index_cities_on_city_name", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.boolean "operating_status"
    t.bigint "ats_type_id", null: false
    t.bigint "company_size_id"
    t.bigint "funding_type_id"
    t.string "linkedin_url"
    t.boolean "is_public"
    t.integer "year_founded"
    t.bigint "city_id"
    t.bigint "state_id"
    t.bigint "country_id", null: false
    t.string "acquired_by"
    t.text "company_description"
    t.bigint "healthcare_domain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ats_id"
    t.index ["ats_type_id"], name: "index_companies_on_ats_type_id"
    t.index ["city_id"], name: "index_companies_on_city_id"
    t.index ["company_name"], name: "index_companies_on_company_name", unique: true
    t.index ["company_size_id"], name: "index_companies_on_company_size_id"
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["funding_type_id"], name: "index_companies_on_funding_type_id"
    t.index ["healthcare_domain_id"], name: "index_companies_on_healthcare_domain_id"
    t.index ["linkedin_url"], name: "index_companies_on_linkedin_url", unique: true
    t.index ["state_id"], name: "index_companies_on_state_id"
  end

  create_table "company_sizes", force: :cascade do |t|
    t.string "size_range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["size_range"], name: "index_company_sizes_on_size_range", unique: true
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
    t.bigint "healthcare_domain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["healthcare_domain_id"], name: "index_company_specialties_on_healthcare_domain_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "country_code"
    t.string "country_name"
    t.string "aliases", default: [], array: true
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_code"], name: "index_countries_on_country_code", unique: true
  end

  create_table "departments", force: :cascade do |t|
    t.string "dept_name"
    t.string "aliases", default: [], array: true
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dept_name"], name: "index_departments_on_dept_name", unique: true
  end

  create_table "funding_types", force: :cascade do |t|
    t.string "funding_type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["funding_type_name"], name: "index_funding_types_on_funding_type_name", unique: true
  end

  create_table "healthcare_domains", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_commitments", force: :cascade do |t|
    t.string "commitment_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commitment_name"], name: "index_job_commitments_on_commitment_name", unique: true
  end

  create_table "job_posts", force: :cascade do |t|
    t.bigint "job_commitment_id"
    t.bigint "job_setting_id", null: false
    t.bigint "country_id"
    t.bigint "department_id", null: false
    t.bigint "team_id", null: false
    t.bigint "company_id", null: false
    t.bigint "job_role_id", null: false
    t.bigint "job_salary_currency_id"
    t.bigint "job_salary_interval_id"
    t.string "job_title"
    t.text "job_description"
    t.string "job_url"
    t.datetime "job_posted"
    t.datetime "job_updated"
    t.boolean "job_active"
    t.bigint "job_internal_id"
    t.bigint "job_url_id"
    t.string "job_internal_id_string"
    t.integer "job_salary_min"
    t.integer "job_salary_max"
    t.text "job_additional"
    t.text "job_responsibilities"
    t.text "job_qualifications"
    t.text "job_applyUrl"
    t.json "job_locations"
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_job_posts_on_company_id"
    t.index ["country_id"], name: "index_job_posts_on_country_id"
    t.index ["department_id"], name: "index_job_posts_on_department_id"
    t.index ["job_active"], name: "index_job_posts_on_job_active"
    t.index ["job_commitment_id"], name: "index_job_posts_on_job_commitment_id"
    t.index ["job_posted"], name: "index_job_posts_on_job_posted"
    t.index ["job_role_id"], name: "index_job_posts_on_job_role_id"
    t.index ["job_salary_currency_id"], name: "index_job_posts_on_job_salary_currency_id"
    t.index ["job_salary_interval_id"], name: "index_job_posts_on_job_salary_interval_id"
    t.index ["job_setting_id"], name: "index_job_posts_on_job_setting_id"
    t.index ["job_url"], name: "index_job_posts_on_job_url", unique: true
    t.index ["team_id"], name: "index_job_posts_on_team_id"
  end

  create_table "job_roles", force: :cascade do |t|
    t.string "role_name"
    t.bigint "department_id", null: false
    t.bigint "team_id", null: false
    t.string "aliases", default: [], array: true
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_job_roles_on_department_id"
    t.index ["role_name"], name: "index_job_roles_on_role_name", unique: true
    t.index ["team_id"], name: "index_job_roles_on_team_id"
  end

  create_table "job_salary_currencies", force: :cascade do |t|
    t.string "currency_code"
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_code"], name: "index_job_salary_currencies_on_currency_code", unique: true
  end

  create_table "job_salary_intervals", force: :cascade do |t|
    t.string "interval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interval"], name: "index_job_salary_intervals_on_interval", unique: true
  end

  create_table "job_settings", force: :cascade do |t|
    t.string "setting_name"
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_name"], name: "index_job_settings_on_setting_name", unique: true
  end

  create_table "states", force: :cascade do |t|
    t.string "state_code"
    t.string "state_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_code"], name: "index_states_on_state_code", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "team_name"
    t.string "aliases", default: [], array: true
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_name"], name: "index_teams_on_team_name", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "whodunnit"
    t.datetime "created_at"
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.string "event", null: false
    t.text "object"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "companies", "ats_types"
  add_foreign_key "companies", "cities"
  add_foreign_key "companies", "company_sizes"
  add_foreign_key "companies", "countries"
  add_foreign_key "companies", "funding_types"
  add_foreign_key "companies", "healthcare_domains"
  add_foreign_key "companies", "states"
  add_foreign_key "company_specializations", "companies"
  add_foreign_key "company_specializations", "company_specialties"
  add_foreign_key "company_specialties", "healthcare_domains"
  add_foreign_key "job_posts", "companies"
  add_foreign_key "job_posts", "countries"
  add_foreign_key "job_posts", "departments"
  add_foreign_key "job_posts", "job_commitments"
  add_foreign_key "job_posts", "job_roles"
  add_foreign_key "job_posts", "job_salary_currencies"
  add_foreign_key "job_posts", "job_salary_intervals"
  add_foreign_key "job_posts", "job_settings"
  add_foreign_key "job_posts", "teams"
  add_foreign_key "job_roles", "departments"
  add_foreign_key "job_roles", "teams"
end
