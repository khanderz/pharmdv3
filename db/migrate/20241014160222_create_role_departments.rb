class CreateRoleDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :role_departments do |t|
      t.string :role_dept_name

      t.timestamps
    end
    add_index :role_departments, :role_dept_name, unique: true
  end
end
