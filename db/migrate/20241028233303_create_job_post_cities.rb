class CreateJobPostCities < ActiveRecord::Migration[7.1]
  def change
    create_table :job_post_cities do |t|
      t.references :job_post, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
