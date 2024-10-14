class CreateJobSalaryIntervals < ActiveRecord::Migration[7.1]
  def change
    create_table :job_salary_intervals do |t|
      t.string :interval

      t.timestamps
    end
    add_index :job_salary_intervals, :interval, unique: true
  end
end
