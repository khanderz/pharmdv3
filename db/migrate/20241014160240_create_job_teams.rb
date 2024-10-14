class CreateJobTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :job_teams do |t|
      t.string :team

      t.timestamps
    end
    add_index :job_teams, :team, unique: true
  end
end
