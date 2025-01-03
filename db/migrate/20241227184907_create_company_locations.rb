# frozen_string_literal: true

class CreateCompanyLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :company_locations do |t|
      t.references :company, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
