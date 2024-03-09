class CreateSoftSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :soft_skills do |t|
      t.string :soft_skill_name
      t.text :soft_skill_description

      t.timestamps
    end
    add_index :soft_skills, :soft_skill_name, unique: true
  end
end
