class CreateCompanyStates < ActiveRecord::Migration[7.1]
  def change
    create_table :company_states do |t|
      t.string :state_name

      t.timestamps
    end
    add_index :company_states, :state_name, unique: true
  end
end
