class CreateHealthcareDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :healthcare_domains do |t|
      t.string :key
      t.string :value
      t.string :aliases, array: true, default: []

      t.timestamps
    end
  end
end
