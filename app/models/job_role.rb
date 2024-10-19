class JobRole < ApplicationRecord
  has_and_belongs_to_many :departments, join_table: :job_roles_departments
  has_and_belongs_to_many :teams, join_table: :job_roles_teams

  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :role_name, presence: true, uniqueness: true

  # Utility method to clean the job title
  def self.clean_job_title(job_title)
    cleaned_title = job_title.gsub(/\(.*?\)/, '')                      
          .split('-').first.strip                
          .gsub(/\b(?:#{State.all.pluck(:state_code, :state_name).flatten.join('|')})\b/i, '') 
          .strip                                   
    cleaned_title
  end

  # Case-insensitive search and create method
  def self.find_or_create_with_department_and_team(job_title, department_name, team_name)
    cleaned_job_title = clean_job_title(job_title)
    puts "Cleaned job title: #{cleaned_job_title}, dept: #{department_name}, team: #{team_name}"
    department = Department.find_department(department_name, 'JobRole', job_title)
    team = Team.find_team(team_name, 'JobRole', job_title)

    job_role = JobRole.find_by('LOWER(role_name) = ?', cleaned_job_title.downcase)

    # If job role is not found, search by aliases
    if job_role.nil?
      job_role = JobRole.where('LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))', cleaned_job_title.downcase).first
    end

    if job_role.nil?
      job_role = JobRole.create!(
        role_name: cleaned_job_title,
        error_details: "Job Role: #{cleaned_job_title} not found in existing records",
        resolved: false
      )

      Adjudication.create!(
        adjudicatable_type: 'JobRole',
        adjudicatable_id: job_role.id,
        error_details: "Job Role: #{cleaned_job_title} not found in existing records",
        resolved: false
      )

      puts "Adjudication created for new job role: #{cleaned_job_title}."
    end
      
  unless job_role.departments.include?(department)
    job_role.departments << department
    puts "Associated Job Role: #{cleaned_job_title} with department: #{department_name}"
  end

  unless job_role.teams.include?(team)
    job_role.teams << team
    puts "Associated Job Role: #{cleaned_job_title} with team: #{team_name}"
  end

    job_role
  end
end
