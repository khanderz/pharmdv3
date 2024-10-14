class CreateJobCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :job_countries do |t|
      t.string :code
      t.string :country

      t.timestamps
    end
    add_index :job_countries, :code, unique: true
  end
end
