class CreateCompanyTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :company_types do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
