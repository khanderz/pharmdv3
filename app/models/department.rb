# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  has_and_belongs_to_many :job_roles, join_table: :job_roles_departments

  validates :dept_name, presence: true, uniqueness: true

  def self.clean_department_name(department_name)
    cleaned_name = department_name.gsub(/^\d+\s*-\s*/, '').strip
    cleaned_name
  end

  def self.find_department(department_name, job_url = nil)
    cleaned_name = clean_department_name(department_name)
    normalized_name = cleaned_name.downcase
    
    department = where('LOWER(dept_name) = ?', normalized_name)
                 .or(where('aliases::text ILIKE ?', "%#{normalized_name}%"))
                 .first
    if department
      puts "#{GREEN}Department #{department_name} found in existing records.#{RESET}"
    else
      department = Department.create!(
        dept_name: department_name,
        error_details: "Department #{department_name} for #{job_url} not found in existing records",
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'Department',
        adjudicatable_id: department.id,
        error_details: "Department #{department_name} for #{job_url} not found in existing records"
      )
    end
    department
  end
end
