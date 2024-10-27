# frozen_string_literal: true

class CreateCompanySpecializations < ActiveRecord::Migration[7.1]
  def change
    create_table :company_specializations do |t|
      t.references :company, null: false, foreign_key: true
      t.references :company_specialty, null: false, foreign_key: true

      t.timestamps
    end
  end
end
