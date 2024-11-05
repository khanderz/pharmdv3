# frozen_string_literal: true

class Team < ApplicationRecord
  has_and_belongs_to_many :job_roles, join_table: :job_roles_teams
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy
  validates :team_name, presence: true, uniqueness: true
  def self.find_team(team_name, adjudicatable_type, relation = nil)
    # Clean the team name using the TitleCleaner utility
    cleaned_team_name = Utils::TitleCleaner.clean_title(team_name)

    # Look for the team by its name or aliases (case-insensitive)
    team = Team.find_by('LOWER(team_name) = ? OR LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                        cleaned_team_name.downcase, cleaned_team_name.downcase)
    if team
      # If the team is found, return it
      return team
    end

    # Check again if the cleaned team name already exists before creating a new record
    team = Team.find_by('LOWER(team_name) = ?', cleaned_team_name.downcase)
    if team
      # Return the found team if it exists
      return team
    end

    # If no existing team is found, create a new one and log the adjudication
    begin
      team = Team.create!(
        team_name: cleaned_team_name,
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
    rescue ActiveRecord::RecordInvalid => e
      puts "Failed to create team #{team_name}: #{e.message}"
    end
    team
  end
end
