class CreateCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :countries do |t|
      t.string :country_code
      t.string :country_name

      t.timestamps
    end
    add_index :countries, :country_code, unique: true
  end
end
