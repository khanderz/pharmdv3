# frozen_string_literal: true

class CreateBenefits < ActiveRecord::Migration[7.1]
  def change
    create_table :benefits do |t|
      t.string :benefit_name
      t.string :benefit_category
      t.string :aliases, array: true, default: []

      t.timestamps
    end
    add_index :benefits, :benefit_name, unique: true
  end
end
