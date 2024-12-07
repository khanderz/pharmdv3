# frozen_string_literal: true

class CreateCompanyTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :company_types do |t|
      t.string :company_type_code
      t.string :company_type_name

      t.timestamps
    end
    add_index :company_types, :company_type_code, unique: true
  end
end
