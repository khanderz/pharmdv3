class AddAdjudicationFieldsToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :error_details, :text
    add_column :companies, :resolved, :boolean
  end
end
