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
     
  def self.find_or_create_with_department_and_team(job_title, department_name, team_name)
    cleaned_job_title = clean_job_title(job_title)

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
    
    job_role = JobRole.find_by('role_name = ? OR ? = ANY (aliases)', cleaned_job_title, cleaned_job_title)

    if job_role.nil?
      job_role = JobRole.create!(
        role_name: cleaned_job_title, 
        department: department, 
        team: team,
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
