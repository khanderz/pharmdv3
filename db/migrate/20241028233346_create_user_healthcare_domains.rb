# frozen_string_literal: true

class CreateUserHealthcareDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :user_healthcare_domains do |t|
      t.references :user, null: false, foreign_key: true
      t.references :healthcare_domain, null: false, foreign_key: true

      t.timestamps
    end
  end
end
