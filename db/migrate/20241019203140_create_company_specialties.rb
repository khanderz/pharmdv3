class CreateCompanySpecialties < ActiveRecord::Migration[7.1]
  def change
    create_table :company_specialties do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end
end
