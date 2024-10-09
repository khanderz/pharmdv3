class CreateCompanyTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :company_types do |t|
      t.string :key, null: false # Enum key like 'PHARMA'
      t.string :value, null: false # Human-readable value like 'Pharmacy'

      t.timestamps
    end

    # Add a unique index on the 'key' column to enforce uniqueness at the database level
    add_index :company_types, :key, unique: true
  end
end
