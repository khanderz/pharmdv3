# frozen_string_literal: true

class Team < ApplicationRecord
  has_and_belongs_to_many :job_roles, join_table: :job_roles_teams
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :team_name, presence: true, uniqueness: true

  def self.find_team(team_name, adjudicatable_type, relation = nil)
    titles = Utils::TitleCleaner.clean_title(team_name)
    cleaned_team_name = titles[:cleaned_title]

    team = where('LOWER(team_name) = ?', cleaned_team_name.downcase)
           .or(
             where('EXISTS (SELECT 1 FROM UNNEST(aliases) AS alias WHERE LOWER(alias) = ?)',
                   cleaned_team_name.downcase)
           ).first
    return team if team

    team = Team.create!(
      team_name: cleaned_team_name
    )

    Adjudication.log_error(
      adjudicatable_type: adjudicatable_type,
      adjudicatable_id: relation.try(:id),
      error_details: "Team #{team_name} for #{relation} not found in existing records",
      resolved: false
    )

    team
  end
end
