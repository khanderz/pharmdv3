class CreateJobRolesDepartmentsJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :job_roles_departments, id: false do |t|
      t.bigint :job_role_id, null: false
      t.bigint :department_id, null: false
    end

    add_index :job_roles_departments, :job_role_id
    add_index :job_roles_departments, :department_id
    add_foreign_key :job_roles_departments, :job_roles
    add_foreign_key :job_roles_departments, :departments
  end
end
