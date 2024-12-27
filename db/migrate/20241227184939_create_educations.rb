class CreateEducations < ActiveRecord::Migration[7.1]
  def change
    create_table :educations do |t|
      t.string :education_code
      t.string :education_name
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :educations, :education_code, unique: true
  end
end
