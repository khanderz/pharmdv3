# frozen_string_literal: true

class CreateResources < ActiveRecord::Migration[7.1]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :resource_type
      t.string :url
      t.text :description
      t.string :aliases, array: true, default: []

      t.timestamps
    end
    add_index :resources, :resource_type
  end
end
