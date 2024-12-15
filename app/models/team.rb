# frozen_string_literal: true

class Team < ApplicationRecord
  has_and_belongs_to_many :job_roles, join_table: :job_roles_teams
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :team_name, presence: true, uniqueness: true

  def self.find_team(team_name, adjudicatable_type, relation = nil)
    titles = Utils::TitleCleaner.clean_title(team_name)
    cleaned_team_name = titles[:cleaned_title]

    team = Team.find_by('LOWER(team_name) = ? OR LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                        cleaned_team_name.downcase, cleaned_team_name.downcase)
    if team
      return team
    else
      team = Team.create!(
        team_name: cleaned_team_name
      )

      Adjudication.log_error(
        adjudicatable_type: adjudicatable_type,
        adjudicatable_id: relation.try(:id),
        error_details: "Team #{team_name} for #{relation} not found in existing records",
        resolved: false
      )
    end
    team
  end
end
