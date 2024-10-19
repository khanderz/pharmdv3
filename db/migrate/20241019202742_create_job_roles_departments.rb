class CreateJobRolesDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :job_roles_departments do |t|
      t.references :job_role, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
