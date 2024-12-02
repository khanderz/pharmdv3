# frozen_string_literal: true

class CreateFundingTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :funding_types do |t|
      t.string :funding_type_name

      t.timestamps
    end
    add_index :funding_types, :funding_type_name, unique: true
  end
end
