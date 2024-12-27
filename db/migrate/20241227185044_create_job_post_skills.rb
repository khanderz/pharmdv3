class CreateJobPostSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :job_post_skills do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
