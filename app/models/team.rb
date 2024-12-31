# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :job_roles_teams
  has_many :job_roles, through: :job_roles_teams
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :team_name, presence: true, uniqueness: true

  def self.find_team(team_name, job_post = nil)
    titles = Utils::TitleCleaner.clean_title(team_name)
    puts "team names after title cleaner: #{titles}"
    cleaned_team_name = titles[:cleaned_title]

    team = where('LOWER(team_name) = ?', cleaned_team_name.downcase)
           .or(
             where('EXISTS (SELECT 1 FROM UNNEST(aliases) AS alias WHERE LOWER(alias) = ?)',
                   cleaned_team_name.downcase)
           ).first

    if team
      puts "#{GREEN}Team #{team_name} found in existing records.#{RESET}"
    else
      adj_type = job_post ? 'JobPost' : 'Team'
      error_details = "team_name #{team_name} for #{job_post} not found in existing records"
      new_team = Team.create!(
        team_name: cleaned_team_name,
        error_details: error_details,
        resolved: false
      )

      Adjudication.log_error(
        adjudicatable_type: adj_type,
        adjudicatable_id: new_team.id,
        error_details: error_details,
        resolved: false
      )
    end

    team
  end
end
