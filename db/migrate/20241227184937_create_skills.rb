# frozen_string_literal: true

class CreateSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :skills do |t|
      t.string :skill_code
      t.string :skill_name
      t.string :aliases, array: true, default: []
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :skills, :skill_code, unique: true
  end
end
