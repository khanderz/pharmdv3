class CreateCompanySizes < ActiveRecord::Migration[7.1]
  def change
    create_table :company_sizes do |t|
      t.string :size_range

      t.timestamps
    end
    add_index :company_sizes, :size_range, unique: true
  end
end
