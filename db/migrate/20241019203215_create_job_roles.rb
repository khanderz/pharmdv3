class CreateJobRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :job_roles do |t|
      t.string :role_name
      t.string :aliases, array: true, default: []
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :job_roles, :role_name, unique: true
  end
end
