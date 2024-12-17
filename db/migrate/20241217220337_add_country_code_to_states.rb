# frozen_string_literal: true

class AddCountryCodeToStates < ActiveRecord::Migration[7.1]
  def change
    add_column :states, :country_code, :string, null: false, default: 'US'

    add_index :states, :country_code
  end
end
