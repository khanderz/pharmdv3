# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  has_many :job_roles_departments
  has_many :job_roles, through: :job_roles_departments

  validates :dept_name, presence: true, uniqueness: true

  def self.clean_department_name(department_name)
    puts "Cleaning department name: #{department_name}"
    # cleaned_name = department_name.gsub(/^\d+\s*-\s*/, '').strip
    cleaned_name = department_name.sub(/^.*?-/, '').strip

    puts "Cleaned department name: #{cleaned_name}"
    parts = cleaned_name.split('-').map(&:strip)
    main_name = parts.first
    puts "Main name: #{main_name}"
    if parts.size > 1
      candidate_name = parts.join(' ')
      puts "Candidate name if parts > 1: #{candidate_name}"
      return candidate_name if exists?(dept_name: candidate_name)
    end
    main_name
  end

  def self.find_department(department_name, job_url = nil)
    cleaned_name = clean_department_name(department_name)
    normalized_name = cleaned_name.downcase

    if normalized_name.include?('headquarters')
      department = find_by(dept_name: 'Executive')
      puts "#{GREEN}Mapped '#{department_name}' to 'Executive' department.#{RESET}"
      return department
    end

    department = where('LOWER(dept_name) = ?', normalized_name)
                 .or(where('aliases::text ILIKE ?', "%#{normalized_name}%"))
                 .first

    if department
      puts "#{GREEN}Department #{department_name} found in existing records.#{RESET}"
    else
      department = Department.create!(
        dept_name: cleaned_name,
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
