class JobRole < ApplicationRecord
  belongs_to :department
  belongs_to :team

  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy 
  
  validates :role_name, presence: true, uniqueness: true
     
  # Class method to find or create a job role and update department and team if necessary
  def self.find_or_create_with_department_and_team(job_title, department_name, team_name)
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
    
    # Find or create the job role
    job_role = JobRole.find_by('role_name = ? OR ? = ANY (aliases)', job_title, job_title)
    
    if job_role.nil?
      job_role = JobRole.create(role_name: job_title, department: department, team: team)

      puts "Created new Job Role: #{job_title} with department: #{department_name} and team: #{team_name}"
    elsif job_role.department.nil? && department.present?
      job_role.update(department: department)

      puts "Updated Job Role: #{job_title} with department: #{department_name}"
    elsif job_role.team.nil? && team.present?
      job_role.update(team: team)

      puts "Updated Job Role: #{job_title} with team: #{team_name}"
    end

    job_role
  end
end