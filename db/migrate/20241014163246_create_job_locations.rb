class CreateJobLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :job_locations do |t|
      t.string :location

      t.timestamps
    end
    add_index :job_locations, :location, unique: true
  end
end
