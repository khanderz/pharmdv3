class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :city_name
      t.string :aliases

      t.timestamps
    end
    add_index :cities, :city_name, unique: true
  end
end
