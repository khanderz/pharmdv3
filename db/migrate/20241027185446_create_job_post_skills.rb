# frozen_string_literal: true

class CreateJobPostSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :job_post_skills do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true
      t.string :skill_category

      t.timestamps
    end
    add_index :job_post_skills, :skill_category
  end
end
