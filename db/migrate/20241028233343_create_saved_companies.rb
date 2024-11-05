# frozen_string_literal: true

class CreateSavedCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_companies do |t|
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
