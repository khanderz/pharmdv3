class CreateCompanyCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :company_countries do |t|
      t.string :country_name

      t.timestamps
    end
    add_index :company_countries, :country_name, unique: true
  end
end
