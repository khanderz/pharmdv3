# frozen_string_literal: true

class CreateUserCompanySpecialties < ActiveRecord::Migration[7.1]
  def change
    create_table :user_company_specialties do |t|
      t.references :user, null: false, foreign_key: true
      t.references :company_specialty, null: false, foreign_key: true

      t.timestamps
    end
  end
end
