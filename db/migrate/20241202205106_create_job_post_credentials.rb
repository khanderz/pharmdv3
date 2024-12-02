# frozen_string_literal: true

class CreateJobPostCredentials < ActiveRecord::Migration[7.1]
  def change
    create_table :job_post_credentials do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :credential, null: false, foreign_key: true

      t.timestamps
    end
  end
end
