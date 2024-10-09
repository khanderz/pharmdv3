class AddCompanyTypeIdToCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :company_type_id, :integer, null: false
    add_foreign_key :companies, :company_types  end
end
