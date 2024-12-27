class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name
      t.string :type
      t.string :code
      t.bigint :parent_id
      t.string :aliases, array: true, default: []
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
  end
end
