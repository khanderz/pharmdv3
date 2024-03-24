class CreateJobPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :job_posts do |t|
      t.references :companies, null: false, foreign_key: true
      t.string :job_title
      t.text :job_description
      t.string :job_url
      t.string :job_location
      t.string :job_dept
      t.datetime :job_posted
      t.datetime :job_updated
      t.boolean :job_active
      t.integer :job_internal_id
      t.string :job_internal_id_string
      t.integer :job_salary_min
      t.integer :job_salary_max
      t.string :job_salary_range
      t.string :job_country
      t.string :job_setting
      t.text :job_additional
      t.string :job_commitment
      t.string :job_team
      t.string :job_allLocations
      t.text :job_responsibilities
      t.text :job_qualifications
      t.text :job_applyUrl

      t.timestamps
    end
    add_index :job_posts, :job_url, unique: true
  end
end
