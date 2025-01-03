# frozen_string_literal: true

class CreateJobPostBenefits < ActiveRecord::Migration[7.1]
  def change
    create_table :job_post_benefits do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :benefit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
