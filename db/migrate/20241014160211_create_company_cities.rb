class CreateCompanyCities < ActiveRecord::Migration[7.1]
  def change
    create_table :company_cities do |t|
      t.string :city_name

      t.timestamps
    end
    add_index :company_cities, :city_name, unique: true
  end
end
