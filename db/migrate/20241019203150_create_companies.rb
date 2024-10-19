class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.boolean :operating_status
      t.references :ats_type, null: false, foreign_key: true
      t.references :company_size, null: true, foreign_key: true
      t.references :funding_type, null: true, foreign_key: true
      t.string :linkedin_url
      t.boolean :is_public
      t.integer :year_founded
      t.references :city, null: true, foreign_key: true
      t.references :state, null: true, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.string :acquired_by
      t.text :company_description
      t.string :ats_id
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :companies, :company_name, unique: true
    add_index :companies, :linkedin_url, unique: true
  end
end
