class CreateCompanyAtsTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :company_ats_types do |t|
      t.string :ats_type_name

      t.timestamps
    end
    add_index :company_ats_types, :ats_type_name, unique: true
  end
end
