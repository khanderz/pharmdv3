class CreateJobRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :job_roles do |t|
      t.string :role_name
      t.string :role_department

      t.timestamps
    end
    add_index :job_roles, :role_name, unique: true
  end
end
