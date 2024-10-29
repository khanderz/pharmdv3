class CreateSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :skills do |t|
      t.string :name
      t.string :aliases, array: true, default: []
      t.string :skill_type

      t.timestamps
    end
    add_index :skills, :name, unique: true
    add_index :skills, :skill_type
  end
end
