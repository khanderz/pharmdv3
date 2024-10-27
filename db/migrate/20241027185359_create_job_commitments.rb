# frozen_string_literal: true

class CreateJobCommitments < ActiveRecord::Migration[7.1]
  def change
    create_table :job_commitments do |t|
      t.string :commitment_name

      t.timestamps
    end
    add_index :job_commitments, :commitment_name, unique: true
  end
end
