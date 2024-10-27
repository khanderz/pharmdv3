# frozen_string_literal: true

class CreateCompanyCities < ActiveRecord::Migration[7.1]
  def change
    create_table :company_cities do |t|
      t.references :company, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
