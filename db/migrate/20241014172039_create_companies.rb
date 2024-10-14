class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.boolean :operating_status
      t.references :ats_type, null: false, foreign_key: true
      t.references :company_size, foreign_key: true, null: true
      t.references :funding_type, foreign_key: true, null: true
      t.string :linkedin_url
      t.boolean :is_public
      t.integer :year_founded
      t.references :city, foreign_key: true, null: true
      t.references :state, foreign_key: true, null: true
      t.references :country, null: false, foreign_key: true
      t.string :acquired_by
      t.text :company_description
      t.references :healthcare_domain, null: false, foreign_key: true

      t.timestamps
    end
    add_index :companies, :company_name, unique: true
    add_index :companies, :linkedin_url, unique: true
  end
end
