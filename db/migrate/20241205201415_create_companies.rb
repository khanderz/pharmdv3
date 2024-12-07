# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.boolean :operating_status
      t.references :ats_type, null: false, foreign_key: true
      t.references :company_size, null: true, foreign_key: true
      t.references :funding_type, null: true, foreign_key: true
      t.string :linkedin_url
      t.string :company_url
      t.references :company_type, null: true, foreign_key: true
      t.integer :year_founded
      t.string :acquired_by
      t.text :company_description
      t.string :ats_id
      t.string :logo_url
      t.string :company_tagline
      t.boolean :is_completely_remote
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :companies, :company_name, unique: true
    add_index :companies, :linkedin_url, unique: true
    add_index :companies, :company_url, unique: true
  end
end
