# frozen_string_literal: true

class CreateCompanyStates < ActiveRecord::Migration[7.1]
  def change
    create_table :company_states do |t|
      t.references :company, null: false, foreign_key: true
      t.references :state, null: false, foreign_key: true

      t.timestamps
    end
  end
end
