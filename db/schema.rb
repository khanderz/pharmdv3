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

ActiveRecord::Schema[7.1].define(version: 2024_12_21_012204) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adjudications", force: :cascade do |t|
    t.string "adjudicatable_type", null: false
    t.bigint "adjudicatable_id", null: false
    t.text "error_details"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adjudicatable_type", "adjudicatable_id"], name: "index_adjudications_on_adjudicatable"
  end

  create_table "aggregated_metrics", force: :cascade do |t|
    t.string "metric_type"
    t.string "reference_type"
    t.bigint "reference_id"
    t.integer "value"
    t.datetime "last_updated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ats_types", force: :cascade do |t|
    t.string "ats_type_code"
    t.string "ats_type_name"
    t.string "domain_matched_url"
    t.string "redirect_url"
    t.string "post_match_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ats_type_code"], name: "index_ats_types_on_ats_type_code", unique: true
  end

  create_table "benefits", force: :cascade do |t|
    t.string "benefit_name"
    t.string "benefit_category"
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved", default: false
    t.index ["benefit_name"], name: "index_benefits_on_benefit_name", unique: true
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
    t.string "company_url"
    t.bigint "company_type_id"
    t.integer "year_founded"
    t.string "acquired_by"
    t.text "company_description"
    t.string "ats_id"
    t.string "logo_url"
    t.string "company_tagline"
    t.boolean "is_completely_remote"
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ats_type_id"], name: "index_companies_on_ats_type_id"
    t.index ["company_name"], name: "index_companies_on_company_name", unique: true
    t.index ["company_size_id"], name: "index_companies_on_company_size_id"
    t.index ["company_type_id"], name: "index_companies_on_company_type_id"
    t.index ["company_url"], name: "index_companies_on_company_url", unique: true
    t.index ["funding_type_id"], name: "index_companies_on_funding_type_id"
    t.index ["linkedin_url"], name: "index_companies_on_linkedin_url", unique: true
  end

  create_table "company_cities", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_company_cities_on_city_id"
    t.index ["company_id"], name: "index_company_cities_on_company_id"
  end

  create_table "company_countries", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_countries_on_company_id"
    t.index ["country_id"], name: "index_company_countries_on_country_id"
  end

  create_table "company_domains", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "healthcare_domain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_domains_on_company_id"
    t.index ["healthcare_domain_id"], name: "index_company_domains_on_healthcare_domain_id"
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
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_states", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "state_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_states_on_company_id"
    t.index ["state_id"], name: "index_company_states_on_state_id"
  end

  create_table "company_types", force: :cascade do |t|
    t.string "company_type_code"
    t.string "company_type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_type_code"], name: "index_company_types_on_company_type_code", unique: true
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

  create_table "credentials", force: :cascade do |t|
    t.string "credential_code"
    t.string "credential_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved", default: false
    t.index ["credential_code"], name: "index_credentials_on_credential_code", unique: true
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

  create_table "educations", force: :cascade do |t|
    t.string "education_code"
    t.string "education_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved", default: false
    t.index ["education_code"], name: "index_educations_on_education_code", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "event_type"
    t.bigint "user_id", null: false
    t.string "reference_type"
    t.bigint "reference_id"
    t.json "metadata"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recorded_at"], name: "index_events_on_recorded_at"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.string "experience_code"
    t.string "experience_name"
    t.integer "min_years"
    t.integer "max_years"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved", default: false
    t.index ["experience_code"], name: "index_experiences_on_experience_code", unique: true
  end

  create_table "funding_types", force: :cascade do |t|
    t.string "funding_type_code"
    t.string "funding_type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["funding_type_code"], name: "index_funding_types_on_funding_type_code", unique: true
  end

  create_table "healthcare_domains", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_commitments", force: :cascade do |t|
    t.string "commitment_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commitment_name"], name: "index_job_commitments_on_commitment_name", unique: true
  end

  create_table "job_post_benefits", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "benefit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["benefit_id"], name: "index_job_post_benefits_on_benefit_id"
    t.index ["job_post_id"], name: "index_job_post_benefits_on_job_post_id"
  end

  create_table "job_post_cities", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "city_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_job_post_cities_on_city_id"
    t.index ["job_post_id"], name: "index_job_post_cities_on_job_post_id"
  end

  create_table "job_post_countries", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_job_post_countries_on_country_id"
    t.index ["job_post_id"], name: "index_job_post_countries_on_job_post_id"
  end

  create_table "job_post_credentials", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "credential_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credential_id"], name: "index_job_post_credentials_on_credential_id"
    t.index ["job_post_id"], name: "index_job_post_credentials_on_job_post_id"
  end

  create_table "job_post_educations", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "education_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["education_id"], name: "index_job_post_educations_on_education_id"
    t.index ["job_post_id"], name: "index_job_post_educations_on_job_post_id"
  end

  create_table "job_post_experiences", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "experience_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["experience_id"], name: "index_job_post_experiences_on_experience_id"
    t.index ["job_post_id"], name: "index_job_post_experiences_on_job_post_id"
  end

  create_table "job_post_seniorities", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "job_seniority_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_post_id"], name: "index_job_post_seniorities_on_job_post_id"
    t.index ["job_seniority_id"], name: "index_job_post_seniorities_on_job_seniority_id"
  end

  create_table "job_post_skills", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_post_id"], name: "index_job_post_skills_on_job_post_id"
    t.index ["skill_id"], name: "index_job_post_skills_on_skill_id"
  end

  create_table "job_post_states", force: :cascade do |t|
    t.bigint "job_post_id", null: false
    t.bigint "state_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_post_id"], name: "index_job_post_states_on_job_post_id"
    t.index ["state_id"], name: "index_job_post_states_on_state_id"
  end

  create_table "job_posts", force: :cascade do |t|
    t.bigint "job_commitment_id"
    t.json "job_setting"
    t.bigint "department_id", null: false
    t.bigint "team_id"
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
    t.integer "job_salary_single"
    t.text "job_additional"
    t.text "job_responsibilities"
    t.text "job_applyUrl"
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "job_qualifications"
    t.index ["company_id"], name: "index_job_posts_on_company_id"
    t.index ["department_id"], name: "index_job_posts_on_department_id"
    t.index ["job_active"], name: "index_job_posts_on_job_active"
    t.index ["job_commitment_id"], name: "index_job_posts_on_job_commitment_id"
    t.index ["job_posted"], name: "index_job_posts_on_job_posted"
    t.index ["job_role_id"], name: "index_job_posts_on_job_role_id"
    t.index ["job_salary_currency_id"], name: "index_job_posts_on_job_salary_currency_id"
    t.index ["job_salary_interval_id"], name: "index_job_posts_on_job_salary_interval_id"
    t.index ["job_url"], name: "index_job_posts_on_job_url", unique: true
    t.index ["team_id"], name: "index_job_posts_on_team_id"
  end

  create_table "job_roles", force: :cascade do |t|
    t.string "role_name"
    t.string "aliases", default: [], array: true
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_name"], name: "index_job_roles_on_role_name", unique: true
  end

  create_table "job_roles_departments", force: :cascade do |t|
    t.bigint "job_role_id", null: false
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_job_roles_departments_on_department_id"
    t.index ["job_role_id"], name: "index_job_roles_departments_on_job_role_id"
  end

  create_table "job_roles_teams", force: :cascade do |t|
    t.bigint "job_role_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_role_id"], name: "index_job_roles_teams_on_job_role_id"
    t.index ["team_id"], name: "index_job_roles_teams_on_team_id"
  end

  create_table "job_salary_currencies", force: :cascade do |t|
    t.string "currency_code"
    t.string "currency_sign"
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

  create_table "job_seniorities", force: :cascade do |t|
    t.string "job_seniority_code"
    t.string "job_seniority_label"
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved", default: false
    t.index ["job_seniority_code"], name: "index_job_seniorities_on_job_seniority_code", unique: true
  end

  create_table "job_settings", force: :cascade do |t|
    t.string "setting_name"
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_name"], name: "index_job_settings_on_setting_name", unique: true
  end

  create_table "membership_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_membership_types_on_name", unique: true
  end

  create_table "metrics", force: :cascade do |t|
    t.string "metric_type"
    t.string "reference_type"
    t.bigint "reference_id"
    t.integer "value"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recorded_at"], name: "index_metrics_on_recorded_at"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.string "url"
    t.text "description"
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type"], name: "index_resources_on_resource_type"
  end

  create_table "saved_companies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_saved_companies_on_company_id"
    t.index ["user_id"], name: "index_saved_companies_on_user_id"
  end

  create_table "saved_job_posts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "job_post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_post_id"], name: "index_saved_job_posts_on_job_post_id"
    t.index ["user_id"], name: "index_saved_job_posts_on_user_id"
  end

  create_table "skill_resources", force: :cascade do |t|
    t.bigint "skill_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_skill_resources_on_resource_id"
    t.index ["skill_id"], name: "index_skill_resources_on_skill_id"
  end

  create_table "skills", force: :cascade do |t|
    t.string "skill_code"
    t.string "skill_name"
    t.string "aliases", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved", default: false
    t.index ["skill_code"], name: "index_skills_on_skill_code", unique: true
  end

  create_table "states", force: :cascade do |t|
    t.string "state_code"
    t.string "state_name"
    t.text "error_details"
    t.bigint "reference_id"
    t.boolean "resolved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country_code", default: "US", null: false
    t.string "aliases", default: [], array: true
    t.index ["country_code"], name: "index_states_on_country_code"
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

  create_table "user_company_specialties", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "company_specialty_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_specialty_id"], name: "index_user_company_specialties_on_company_specialty_id"
    t.index ["user_id"], name: "index_user_company_specialties_on_user_id"
  end

  create_table "user_healthcare_domains", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "healthcare_domain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["healthcare_domain_id"], name: "index_user_healthcare_domains_on_healthcare_domain_id"
    t.index ["user_id"], name: "index_user_healthcare_domains_on_user_id"
  end

  create_table "user_resources", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_id"], name: "index_user_resources_on_resource_id"
    t.index ["user_id"], name: "index_user_resources_on_user_id"
  end

  create_table "user_skills", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "skill_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "credential"
    t.json "resume"
    t.string "photo"
    t.datetime "last_login"
    t.string "password_digest"
    t.string "salt"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.string "provider"
    t.string "uid"
    t.string "access_token"
    t.bigint "membership_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["membership_type_id"], name: "index_users_on_membership_type_id"
    t.index ["uid"], name: "index_users_on_uid"
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
  add_foreign_key "companies", "company_sizes"
  add_foreign_key "companies", "company_types"
  add_foreign_key "companies", "funding_types"
  add_foreign_key "company_cities", "cities"
  add_foreign_key "company_cities", "companies"
  add_foreign_key "company_countries", "companies"
  add_foreign_key "company_countries", "countries"
  add_foreign_key "company_domains", "companies"
  add_foreign_key "company_domains", "healthcare_domains"
  add_foreign_key "company_specializations", "companies"
  add_foreign_key "company_specializations", "company_specialties"
  add_foreign_key "company_states", "companies"
  add_foreign_key "company_states", "states"
  add_foreign_key "events", "users"
  add_foreign_key "job_post_benefits", "benefits"
  add_foreign_key "job_post_benefits", "job_posts"
  add_foreign_key "job_post_cities", "cities"
  add_foreign_key "job_post_cities", "job_posts"
  add_foreign_key "job_post_countries", "countries"
  add_foreign_key "job_post_countries", "job_posts"
  add_foreign_key "job_post_credentials", "credentials"
  add_foreign_key "job_post_credentials", "job_posts"
  add_foreign_key "job_post_educations", "educations"
  add_foreign_key "job_post_educations", "job_posts"
  add_foreign_key "job_post_experiences", "experiences"
  add_foreign_key "job_post_experiences", "job_posts"
  add_foreign_key "job_post_seniorities", "job_posts"
  add_foreign_key "job_post_seniorities", "job_seniorities"
  add_foreign_key "job_post_skills", "job_posts"
  add_foreign_key "job_post_skills", "skills"
  add_foreign_key "job_post_states", "job_posts"
  add_foreign_key "job_post_states", "states"
  add_foreign_key "job_posts", "companies"
  add_foreign_key "job_posts", "departments"
  add_foreign_key "job_posts", "job_commitments"
  add_foreign_key "job_posts", "job_roles"
  add_foreign_key "job_posts", "job_salary_currencies"
  add_foreign_key "job_posts", "job_salary_intervals"
  add_foreign_key "job_posts", "teams"
  add_foreign_key "job_roles_departments", "departments"
  add_foreign_key "job_roles_departments", "job_roles"
  add_foreign_key "job_roles_teams", "job_roles"
  add_foreign_key "job_roles_teams", "teams"
  add_foreign_key "saved_companies", "companies"
  add_foreign_key "saved_companies", "users"
  add_foreign_key "saved_job_posts", "job_posts"
  add_foreign_key "saved_job_posts", "users"
  add_foreign_key "skill_resources", "resources"
  add_foreign_key "skill_resources", "skills"
  add_foreign_key "user_company_specialties", "company_specialties"
  add_foreign_key "user_company_specialties", "users"
  add_foreign_key "user_healthcare_domains", "healthcare_domains"
  add_foreign_key "user_healthcare_domains", "users"
  add_foreign_key "user_resources", "resources"
  add_foreign_key "user_resources", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
  add_foreign_key "users", "membership_types"
end
