class CreateJobSalaryCurrencies < ActiveRecord::Migration[7.1]
  def change
    create_table :job_salary_currencies do |t|
      t.string :currency_code
      t.string :currency_sign
      t.text :error_details
      t.bigint :reference_id
      t.boolean :resolved

      t.timestamps
    end
    add_index :job_salary_currencies, :currency_code, unique: true
  end
end
