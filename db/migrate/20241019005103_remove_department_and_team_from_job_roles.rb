class RemoveDepartmentAndTeamFromJobRoles < ActiveRecord::Migration[7.1]
  def change
    remove_column :job_roles, :department_id, :bigint
    remove_column :job_roles, :team_id, :bigint
  end
end
