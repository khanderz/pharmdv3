class CreateJobDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :job_departments do |t|
      t.string :department

      t.timestamps
    end
    add_index :job_departments, :department, unique: true
  end
end
