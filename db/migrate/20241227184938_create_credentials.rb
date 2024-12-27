# frozen_string_literal: true

class CreateCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :credentials do |t|
      t.string :credential_code
      t.string :credential_name
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :credentials, :credential_code, unique: true
  end
end
