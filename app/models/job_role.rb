class JobRole < ApplicationRecord
  has_many :job_posts

  # Storing additional role details in JSON format
  store :additional_attributes, accessors: [:job_function, :clearance_level], coder: JSON
  
  # roles with similar names
  serialize :aliases, JSON # Add JSON as the coder
  
  validates :role_name, presence: true, uniqueness: true

  # Class method to find or create a job role and update department if necessary
  def self.find_or_create_with_department(job_title, role_department)
    job_role = JobRole.find_by('role_name = ? OR ? = ANY (aliases)', job_title, job_title)

    if job_role.nil?
      job_role = JobRole.create(role_name: job_title, role_department: role_department)
      puts "Created new Job Role: #{job_title} with department: #{role_department}"
    elsif job_role.role_department.nil? && role_department.present?
      job_role.update(role_department: role_department)
      puts "Updated Job Role: #{job_title} with department: #{role_department}"
    end

    job_role
  end
end
