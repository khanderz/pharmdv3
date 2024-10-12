class CreateCompanySpecialties < ActiveRecord::Migration[7.1]
  def change
    create_table :company_specialties do |t|
      t.string :name
      t.references :company_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
