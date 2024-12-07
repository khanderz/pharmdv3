# frozen_string_literal: true

class CreateJobSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :job_settings do |t|
      t.string :setting_name
      t.string :aliases, array: true, default: []

      t.timestamps
    end
    add_index :job_settings, :setting_name, unique: true
  end
end
