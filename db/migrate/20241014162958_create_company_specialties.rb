class CreateCompanySpecialties < ActiveRecord::Migration[7.1]
  def change
    create_table :company_specialties do |t|
      t.string :key
      t.string :value
      t.references :healthcare_domain, null: false, foreign_key: true

      t.timestamps
    end
  end
end
