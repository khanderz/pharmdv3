class CreateCompanyCountries < ActiveRecord::Migration[7.1]
  def change
    create_table :company_countries do |t|
      t.references :company, null: false, foreign_key: true
      t.references :country, null: false, foreign_key: true

      t.timestamps
    end
  end
end
