class CreateHealthcareDomains < ActiveRecord::Migration[7.1]
  def change
    create_table :healthcare_domains do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end