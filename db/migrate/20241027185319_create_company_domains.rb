# frozen_string_literal: true

class CreateCompanyDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :company_domains do |t|
      t.references :company, null: false, foreign_key: true
      t.references :healthcare_domain, null: false, foreign_key: true

      t.timestamps
    end
  end
end
