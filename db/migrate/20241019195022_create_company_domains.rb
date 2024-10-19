class CreateCompanyDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :company_domains do |t|
      t.references :company, null: false, foreign_key: true
      t.references :healthcare_domain, null: false, foreign_key: true

      t.timestamps
    end

    # Optionally, remove healthcare_domain_id from companies table
    remove_column :companies, :healthcare_domain_id, :bigint
  end
end