# frozen_string_literal: true

class CreateStates < ActiveRecord::Migration[7.1]
  def change
    create_table :states do |t|
      t.string :state_code
      t.string :state_name
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :states, :state_code, unique: true
  end
end
