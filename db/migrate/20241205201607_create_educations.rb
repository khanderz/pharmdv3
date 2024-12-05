class CreateEducations < ActiveRecord::Migration[7.1]
  def change
    create_table :educations do |t|
      t.string :education_code
      t.string :education_name

      t.timestamps
    end
    add_index :educations, :education_code, unique: true
  end
end
