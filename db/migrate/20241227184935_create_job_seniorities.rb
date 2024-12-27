# frozen_string_literal: true

class CreateJobSeniorities < ActiveRecord::Migration[7.1]
  def change
    create_table :job_seniorities do |t|
      t.string :job_seniority_code
      t.string :job_seniority_label
      t.string :aliases, array: true, default: []
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :job_seniorities, :job_seniority_code, unique: true
  end
end
