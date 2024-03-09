class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.references :job_posts, null: false, foreign_key: true
      t.string :tag_name

      t.timestamps
    end
    add_index :tags, :tag_name, unique: true
  end
end
