class ChangeAliasesToArrayInJobRoles < ActiveRecord::Migration[7.1]
  def change
    change_column :job_roles, :aliases, :string, array: true, default: [], using: 'string_to_array(aliases, \',\')'
  end
end
