class CreateStates < ActiveRecord::Migration[7.1]
  def change
    create_table :states do |t|
      t.string :state_code
      t.string :state_name

      t.timestamps
    end
    add_index :states, :state_code, unique: true
  end
end
