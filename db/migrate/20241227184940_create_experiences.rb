class CreateExperiences < ActiveRecord::Migration[7.1]
  def change
    create_table :experiences do |t|
      t.string :experience_code
      t.string :experience_name
      t.integer :min_years
      t.integer :max_years
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :experiences, :experience_code, unique: true
  end
end
