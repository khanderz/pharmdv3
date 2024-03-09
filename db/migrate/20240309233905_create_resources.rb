class CreateResources < ActiveRecord::Migration[7.1]
  def change
    create_table :resources do |t|
      t.references :tech_skills, null: false, foreign_key: true
      t.references :soft_skills, null: false, foreign_key: true
      t.string :resource_name
      t.text :resource_description
      t.string :resource_url

      t.timestamps
    end
    add_index :resources, :resource_name, unique: true
    add_index :resources, :resource_url, unique: true
  end
end
