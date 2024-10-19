class JobRole < ApplicationRecord
  has_and_belongs_to_many :departments
  has_and_belongs_to_many :teams

  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :role_name, presence: true, uniqueness: true

  # Utility method to clean the job title
  def self.clean_job_title(job_title)
    cleaned_title = job_title.gsub(/\(.*?\)/, '').strip
    cleaned_title.split(',').first.strip
  end

  # Case-insensitive search and create method
  def self.find_or_create_with_department_and_team(job_title, department_name, team_name)
    cleaned_job_title = clean_job_title(job_title)
    department = Department.find_department(department_name, 'JobRole', job_title)
    team = Team.find_team(team_name, 'JobRole', job_title)

    # First, attempt to find the job role by role_name
    job_role = JobRole.find_by('LOWER(role_name) = ?', cleaned_job_title.downcase)

    # If no direct match is found, attempt to find by aliases
    if job_role.nil?
      job_role = JobRole.joins(:adjudications).find_by('? = ANY (aliases)', cleaned_job_title.downcase)
    end

    # If still no job role found, create a new one
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
    elsif job_role.department.nil? || job_role.department != department
      job_role.update(department: department)
      puts "Updated Job Role: #{cleaned_job_title} with department: #{department_name}"
    elsif job_role.team.nil? || job_role.team != team
      job_role.update(team: team)
      puts "Updated Job Role: #{cleaned_job_title} with team: #{team_name}"
    end

    job_role
  end
end
