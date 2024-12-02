# frozen_string_literal: true

class CreateSavedJobPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_job_posts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :job_post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
