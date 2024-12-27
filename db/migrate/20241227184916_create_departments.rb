class CreateDepartments < ActiveRecord::Migration[7.1]
  def change
    create_table :departments do |t|
      t.string :dept_name
      t.string :aliases
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :departments, :dept_name, unique: true
  end
end
