class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :team_name

      t.timestamps
    end
    add_index :teams, :team_name, unique: true
  end
end
