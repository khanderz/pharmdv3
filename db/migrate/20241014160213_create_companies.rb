class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.boolean :operating_status
      t.references :company_ats_type, null: false, foreign_key: true
      t.references :company_size, null: false, foreign_key: true
      t.references :funding_type, null: false, foreign_key: true
      t.string :linkedin_url
      t.boolean :is_public
      t.integer :year_founded
      t.references :company_city, null: false, foreign_key: true
      t.references :company_state, null: false, foreign_key: true
      t.references :company_country, null: false, foreign_key: true
      t.string :acquired_by
      t.string :ats_id
      t.text :company_description
      t.references :company_type, null: false, foreign_key: true

      t.timestamps
    end
    add_index :companies, :company_name, unique: true
    add_index :companies, :linkedin_url, unique: true
  end
end
