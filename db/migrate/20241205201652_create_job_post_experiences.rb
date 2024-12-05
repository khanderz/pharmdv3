class CreateJobPostExperiences < ActiveRecord::Migration[7.1]
  def change
    create_table :job_post_experiences do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :experience, null: false, foreign_key: true

      t.timestamps
    end
  end
end
