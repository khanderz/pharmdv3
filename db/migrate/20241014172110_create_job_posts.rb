class CreateJobPosts < ActiveRecord::Migration[7.1]
  def change
    create_table :job_posts do |t|
      t.references :job_commitment, null: true, foreign_key: true
      t.references :job_setting, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.references :job_role, null: false, foreign_key: true
      t.references :job_salary_currency, null: true, foreign_key: true
      t.references :job_salary_interval, null: true, foreign_key: true
      t.string :job_title
      t.text :job_description
      t.string :job_url
      t.datetime :job_posted
      t.datetime :job_updated
      t.boolean :job_active
      t.bigint :job_internal_id
      t.bigint :job_url_id
      t.string :job_internal_id_string
      t.integer :job_salary_min
      t.integer :job_salary_max
      t.text :job_additional
      t.text :job_responsibilities
      t.text :job_qualifications
      t.text :job_applyUrl
      t.json :job_locations

      t.timestamps
    end
    add_index :job_posts, :job_url, unique: true
    add_index :job_posts, :job_posted
    add_index :job_posts, :job_active
  end
end
