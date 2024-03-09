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

ActiveRecord::Schema[7.1].define(version: 2024_03_09_233905) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.boolean "operating_status"
    t.string "company_type"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_name"], name: "index_companies_on_company_name", unique: true
    t.index ["linkedin_url"], name: "index_companies_on_linkedin_url", unique: true
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
    t.integer "job_internal_id"
    t.string "job_internal_id_string"
    t.integer "job_salary_min"
    t.integer "job_salary_max"
    t.string "job_salary_range"
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

  create_table "resources", force: :cascade do |t|
    t.bigint "tech_skills_id", null: false
    t.bigint "soft_skills_id", null: false
    t.string "resource_name"
    t.text "resource_description"
    t.string "resource_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_name"], name: "index_resources_on_resource_name", unique: true
    t.index ["resource_url"], name: "index_resources_on_resource_url", unique: true
    t.index ["soft_skills_id"], name: "index_resources_on_soft_skills_id"
    t.index ["tech_skills_id"], name: "index_resources_on_tech_skills_id"
  end

  create_table "soft_skills", force: :cascade do |t|
    t.string "soft_skill_name"
    t.text "soft_skill_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["soft_skill_name"], name: "index_soft_skills_on_soft_skill_name", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "job_posts_id", null: false
    t.string "tag_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_posts_id"], name: "index_tags_on_job_posts_id"
    t.index ["tag_name"], name: "index_tags_on_tag_name", unique: true
  end

  create_table "tech_skills", force: :cascade do |t|
    t.string "tech_skill_name"
    t.text "tech_skill_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tech_skill_name"], name: "index_tech_skills_on_tech_skill_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password"
    t.string "user_type"
    t.string "user_resume"
    t.string "user_photo"
    t.datetime "user_last_login", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "job_posts", "companies", column: "companies_id"
  add_foreign_key "resources", "soft_skills", column: "soft_skills_id"
  add_foreign_key "resources", "tech_skills", column: "tech_skills_id"
  add_foreign_key "tags", "job_posts", column: "job_posts_id"
end
