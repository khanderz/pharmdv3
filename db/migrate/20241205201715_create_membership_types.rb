# frozen_string_literal: true

class CreateMembershipTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :membership_types do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :duration

      t.timestamps
    end
    add_index :membership_types, :name, unique: true
  end
end
