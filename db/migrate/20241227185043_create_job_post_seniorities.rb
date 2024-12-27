# frozen_string_literal: true

class CreateJobPostSeniorities < ActiveRecord::Migration[7.1]
  def change
    create_table :job_post_seniorities do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :job_seniority, null: false, foreign_key: true

      t.timestamps
    end
  end
end
