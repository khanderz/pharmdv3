class JobRole < ApplicationRecord
  belongs_to :department
  belongs_to :team

  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy 
  
  validates :role_name, presence: true, uniqueness: true

  def self.clean_job_title(job_title)
    cleaned_title = job_title.gsub(/\(.*?\)/, '').strip
    
    cleaned_title = cleaned_title.split(',').first.strip
    
    cleaned_title
  end
     
  # Class method to find or create a job role and update department and team if necessary
  def self.find_or_create_with_department_and_team(job_title, department_name, team_name)
    # Preprocess job title to remove extraneous information like "(2025 New Grad)"
    cleaned_job_title = clean_job_title(job_title)
    puts "job_title: #{job_title} ,Cleaned job title: #{cleaned_job_title}"

    # Find the department by name or its aliases
    department = Department.find_by('dept_name = ? OR ? = ANY (aliases)', department_name, department_name)
    
    if department.nil?
      new_department = Department.create!(
        dept_name: department_name,
        error_details: "Department #{department_name} for job role #{job_title} not found in existing records",
        resolved: false
      )

      Adjudication.create!(
        adjudicatable_type: 'JobRole',
        adjudicatable_id: new_department.id,
        error_details: "Department #{department_name} for job role #{job_title} not found in existing records",
        resolved: false
      )

      puts "Department #{department_name} for job role #{job_title} not found. Logged to adjudications."
      return
    end

    # Find the team by name or its aliases
    team = Team.find_by('team_name = ? OR ? = ANY (aliases)', team_name, team_name)
    
    if team.nil?
      new_team = Team.create!(
        team_name: team_name,
        error_details: "Team #{team_name} for job role #{job_title} not found in existing records",
        resolved: false
      )

      Adjudication.create!(
        adjudicatable_type: 'JobRole',
        adjudicatable_id: new_team.id,
        error_details: "Team #{team_name} for job role #{job_title} not found in existing records",
        resolved: false
      )

      puts "Team #{team_name} for job role #{job_title} not found. Logged to adjudications."
      return
    end
    
    # Find the job role by cleaned job title or its aliases
    job_role = JobRole.find_by('role_name = ? OR ? = ANY (aliases)', cleaned_job_title, cleaned_job_title)

    if job_role.nil?
      # Create the new job role
      job_role = JobRole.create!(
        role_name: cleaned_job_title, 
        department: department, 
        team: team
      )

      puts "Created new Job Role: #{cleaned_job_title} with department: #{department_name} and team: #{team_name}"
    elsif job_role.department.nil? && department.present?
      job_role.update(department: department)

      puts "Updated Job Role: #{cleaned_job_title} with department: #{department_name}"
    elsif job_role.team.nil? && team.present?
      job_role.update(team: team)

      puts "Updated Job Role: #{cleaned_job_title} with team: #{team_name}"
    end

    job_role
  end
end
