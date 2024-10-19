class JobRole < ApplicationRecord
  has_and_belongs_to_many :departments, join_table: :job_roles_departments
  has_and_belongs_to_many :teams, join_table: :job_roles_teams

  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :role_name, presence: true, uniqueness: true

  # Utility method to clean the job title
  def self.clean_job_title(job_title)
    cleaned_title = job_title.gsub(/\(.*?\)/, '')
                             .split(/[-,]/).first.strip
  
    states = State.all.pluck(:state_code, :state_name).flatten.map { |s| Regexp.escape(s) }
    state_pattern = /\b(#{states.join('|')})\b/i
  
    cleaned_title.gsub!(state_pattern, '')
  
    cleaned_title.strip
  end
  

  # Case-insensitive search and create method
  def self.find_or_create_with_department_and_team(job_title, department_names, team_names)
    cleaned_job_title = clean_job_title(job_title)
    puts "Cleaned job title: #{cleaned_job_title} dept: #{department_names} team: #{team_names}"

    department_names = Array(department_names)
    team_names = Array(team_names)
    
    departments = department_names.map do |department_name|
      Department.find_department(department_name, 'JobRole', job_title)
    end
    
    teams = team_names.map do |team_name|
      Team.find_team(team_name, 'JobRole', job_title)
    end
  
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
    
    departments.each do |department|
      unless job_role.departments.include?(department)
        job_role.departments << department
        puts "Associated Job Role: #{cleaned_job_title} with department: #{department.dept_name}"
      end
    end
  
    teams.each do |team|
      unless job_role.teams.include?(team)
        job_role.teams << team
        puts "Associated Job Role: #{cleaned_job_title} with team: #{team.team_name}"
      end
    end
  
    job_role
  end
  
end
