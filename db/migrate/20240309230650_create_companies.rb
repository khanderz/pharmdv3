class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.boolean :operating_status
      t.string :company_type
      t.string :company_ats_type
      t.string :company_size
      t.string :last_funding_type
      t.string :linkedin_url
      t.boolean :is_public
      t.integer :year_founded
      t.string :company_city
      t.string :company_state
      t.string :company_country
      t.string :acquired_by
      t.string :ats_id

      t.timestamps
    end
    add_index :companies, :company_name, unique: true
    add_index :companies, :linkedin_url, unique: true
  end
end
