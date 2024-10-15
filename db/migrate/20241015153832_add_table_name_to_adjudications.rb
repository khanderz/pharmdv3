class AddTableNameToAdjudications < ActiveRecord::Migration[7.1]
  def change
    add_column :adjudications, :table_name, :string
  end
end
