class RemoveTableNameFromAdjudications < ActiveRecord::Migration[7.1]
  def change
    remove_column :adjudications, :table_name, :string
  end
end
