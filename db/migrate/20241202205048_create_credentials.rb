# frozen_string_literal: true

class CreateCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :credentials do |t|
      t.string :credential_code
      t.string :credential_name

      t.timestamps
    end
    add_index :credentials, :credential_code, unique: true
  end
end
