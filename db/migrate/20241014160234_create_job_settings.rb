class CreateJobSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :job_settings do |t|
      t.string :setting

      t.timestamps
    end
    add_index :job_settings, :setting, unique: true
  end
end
