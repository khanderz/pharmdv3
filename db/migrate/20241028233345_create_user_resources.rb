# frozen_string_literal: true

class CreateUserResources < ActiveRecord::Migration[7.1]
  def change
    create_table :user_resources do |t|
      t.references :user, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
