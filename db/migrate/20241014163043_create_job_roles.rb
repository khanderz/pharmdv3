class CreateJobRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :job_roles do |t|
      t.string :role_name
      t.references :department, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :aliases, array: true, default: []

      t.timestamps
    end
    add_index :job_roles, :role_name, unique: true
  end
end
