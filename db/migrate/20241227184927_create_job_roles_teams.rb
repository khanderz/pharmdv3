# frozen_string_literal: true

class CreateJobRolesTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :job_roles_teams do |t|
      t.references :job_role, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
