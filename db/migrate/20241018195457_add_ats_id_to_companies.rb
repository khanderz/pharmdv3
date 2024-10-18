class AddAtsIdToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :ats_id, :string
  end
end
