class CreateJobPostEducations < ActiveRecord::Migration[7.1]
  def change
    create_table :job_post_educations do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :education, null: false, foreign_key: true

      t.timestamps
    end
  end
end
