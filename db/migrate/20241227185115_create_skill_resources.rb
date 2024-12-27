class CreateSkillResources < ActiveRecord::Migration[7.1]
  def change
    create_table :skill_resources do |t|
      t.references :skill, null: false, foreign_key: true
      t.references :resource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
