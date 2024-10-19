class CreateJobRolesTeamsJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :job_roles_teams, id: false do |t|
      t.bigint :job_role_id, null: false
      t.bigint :team_id, null: false
    end

    add_index :job_roles_teams, :job_role_id
    add_index :job_roles_teams, :team_id
    add_foreign_key :job_roles_teams, :job_roles
    add_foreign_key :job_roles_teams, :teams
  end
end
