# frozen_string_literal: true

class CreateCompanyDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :company_domains do |t|
      t.references :company, null: false, foreign_key: true
      t.references :healthcare_domain, null: false, foreign_key: true

      t.timestamps
    end
    add_index :company_domains, %i[company_id healthcare_domain_id], unique: true,
                                                                     name: 'index_company_domains_on_company_and_healthcare_domain'
  end
end
