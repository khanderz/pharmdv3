class CreateTechSkills < ActiveRecord::Migration[7.1]
  def change
    create_table :tech_skills do |t|
      t.string :tech_skill_name
      t.text :tech_skill_description

      t.timestamps
    end
    add_index :tech_skills, :tech_skill_name, unique: true
  end
end
