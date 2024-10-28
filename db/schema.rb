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

ActiveRecord::Schema[7.1].define(version: 20_241_028_175_100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'ats_types', force: :cascade do |t|
    t.string 'ats_type_code'
    t.string 'ats_type_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['ats_type_code'], name: 'index_ats_types_on_ats_type_code', unique: true
  end

  create_table 'cities', force: :cascade do |t|
    t.string 'city_name'
    t.string 'aliases', default: [], array: true
    t.text 'error_details'
    t.bigint 'reference_id'
    t.boolean 'resolved'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['city_name'], name: 'index_cities_on_city_name', unique: true
  end

  create_table 'companies', force: :cascade do |t|
    t.string 'company_name'
    t.boolean 'operating_status'
    t.bigint 'ats_type_id', null: false
    t.bigint 'company_size_id'
    t.bigint 'funding_type_id'
    t.string 'linkedin_url'
    t.string 'company_url'
    t.boolean 'is_public'
    t.integer 'year_founded'
    t.string 'acquired_by'
    t.text 'company_description'
    t.string 'ats_id'
    t.text 'error_details'
    t.bigint 'reference_id'
    t.boolean 'resolved'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['ats_type_id'], name: 'index_companies_on_ats_type_id'
    t.index ['company_name'], name: 'index_companies_on_company_name', unique: true
    t.index ['company_size_id'], name: 'index_companies_on_company_size_id'
    t.index ['company_url'], name: 'index_companies_on_company_url', unique: true
    t.index ['funding_type_id'], name: 'index_companies_on_funding_type_id'
    t.index ['linkedin_url'], name: 'index_companies_on_linkedin_url', unique: true
  end

  create_table 'company_cities', force: :cascade do |t|
    t.bigint 'company_id', null: false
    t.bigint 'city_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['city_id'], name: 'index_company_cities_on_city_id'
    t.index ['company_id'], name: 'index_company_cities_on_company_id'
  end

  create_table 'company_countries', force: :cascade do |t|
    t.bigint 'company_id', null: false
    t.bigint 'country_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['company_id'], name: 'index_company_countries_on_company_id'
    t.index ['country_id'], name: 'index_company_countries_on_country_id'
  end

  create_table 'company_domains', force: :cascade do |t|
    t.bigint 'company_id', null: false
    t.bigint 'healthcare_domain_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['company_id'], name: 'index_company_domains_on_company_id'
    t.index ['healthcare_domain_id'], name: 'index_company_domains_on_healthcare_domain_id'
  end

  create_table 'company_sizes', force: :cascade do |t|
    t.string 'size_range'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['size_range'], name: 'index_company_sizes_on_size_range', unique: true
  end

  create_table 'company_specializations', force: :cascade do |t|
    t.bigint 'company_id', null: false
    t.bigint 'company_specialty_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['company_id'], name: 'index_company_specializations_on_company_id'
    t.index ['company_specialty_id'], name: 'index_company_specializations_on_company_specialty_id'
  end

  create_table 'company_specialties', force: :cascade do |t|
    t.string 'key'
    t.string 'value'
    t.string 'aliases', default: [], array: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'company_states', force: :cascade do |t|
    t.bigint 'company_id', null: false
    t.bigint 'state_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['company_id'], name: 'index_company_states_on_company_id'
    t.index ['state_id'], name: 'index_company_states_on_state_id'
  end

  create_table 'countries', force: :cascade do |t|
    t.string 'country_code'
    t.string 'country_name'
    t.string 'aliases', default: [], array: true
    t.text 'error_details'
    t.bigint 'reference_id'
    t.boolean 'resolved'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['country_code'], name: 'index_countries_on_country_code', unique: true
  end

  create_table 'funding_types', force: :cascade do |t|
    t.string 'funding_type_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['funding_type_name'], name: 'index_funding_types_on_funding_type_name', unique: true
  end

  create_table 'healthcare_domains', force: :cascade do |t|
    t.string 'key'
    t.string 'value'
    t.string 'aliases', default: [], array: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'states', force: :cascade do |t|
    t.string 'state_code'
    t.string 'state_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['state_code'], name: 'index_states_on_state_code', unique: true
  end

  create_table 'versions', force: :cascade do |t|
    t.string 'whodunnit'
    t.datetime 'created_at'
    t.bigint 'item_id', null: false
    t.string 'item_type', null: false
    t.string 'event', null: false
    t.text 'object'
    t.index %w[item_type item_id], name: 'index_versions_on_item_type_and_item_id'
  end

  add_foreign_key 'companies', 'ats_types'
  add_foreign_key 'companies', 'company_sizes'
  add_foreign_key 'companies', 'funding_types'
  add_foreign_key 'company_cities', 'cities'
  add_foreign_key 'company_cities', 'companies'
  add_foreign_key 'company_countries', 'companies'
  add_foreign_key 'company_countries', 'countries'
  add_foreign_key 'company_domains', 'companies'
  add_foreign_key 'company_domains', 'healthcare_domains'
  add_foreign_key 'company_specializations', 'companies'
  add_foreign_key 'company_specializations', 'company_specialties'
  add_foreign_key 'company_states', 'companies'
  add_foreign_key 'company_states', 'states'
end
