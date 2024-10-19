class Team < ApplicationRecord
    has_and_belongs_to_many :job_roles, join_table: :job_roles_teams

    has_many :job_posts
    has_many :adjudications, as: :adjudicatable, dependent: :destroy 

    validates :team_name, presence: true, uniqueness: true

    def self.find_team(team_name, adjudicatable_type, relation = nil)
        team = Team.find_by('LOWER(team_name) = ? OR LOWER(?) = ANY (aliases)', team_name.downcase, team_name.downcase)

        if team.nil?
            team = Team.create!(
                team_name: team_name,
                error_details: "Team #{team_name} for #{relation} not found in existing records",
                resolved: false
            )

            Adjudication.create!(
                adjudicatable_type: adjudicatable_type,
                adjudicatable_id: team.id,
                error_details: "Team #{team_name} for #{relation} not found in existing records",
                resolved: false
            )

            puts "Team #{team_name} created and logged to adjudications with adjudicatable_type #{adjudicatable_type}."
        end
        team
    end
end