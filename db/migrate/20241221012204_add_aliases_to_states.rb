class AddAliasesToStates < ActiveRecord::Migration[7.1]
  def change
    add_column :states, :aliases, :string, array: true, default: []
  end
end
