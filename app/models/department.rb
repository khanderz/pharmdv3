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

    puts "Finding department: #{cleaned_name}"
    puts "Normalized name: #{normalized_name}"

    if normalized_name.include?('headquarters')
      department = find_by(dept_name: 'Executive')
      puts "#{ORANGE}normalized name match to headquarters, matching department to Executive#{RESET}"

      return department if department
    end

    if normalized_name.include?('clinical')
      department = find_by(dept_name: 'Clinical Team')
      puts "#{ORANGE}normalized name match to clinical, matching department to Clinical Team#{RESET}"
      return department if department
    end

    if normalized_name.include?('sales')
      department = find_by(dept_name: 'Sales')
      puts "#{ORANGE}normalized name match to sales, matching department to Sales#{RESET}"
      return department if department
    end

    if normalized_name.include?('marketing')
      department = find_by(dept_name: 'Marketing')
      puts "#{ORANGE}normalized name match to marketing, matching department to Marketing#{RESET}"
      return department if department
    end

    if normalized_name.include?('operations')
      department = find_by(dept_name: 'Operations')
      puts "#{ORANGE}normalized name match to operations, matching department to Operations#{RESET}"
      return department if department
    end

    if normalized_name.include?('data')
      department = find_by(dept_name: 'Data Science')
      puts "#{ORANGE}normalized name match to data, matching department to Data Science#{RESET}"
      return department if department
    end

    if normalized_name.include?('technology')
      department = find_by(dept_name: 'IT')
      puts "#{ORANGE}normalized name match to technology, matching department to IT#{RESET}"
      return department if department
    end

    if normalized_name.include?('quality')
      department = find_by(dept_name: 'Quality')
      puts "#{ORANGE}normalized name match to quality, matching department to Quality#{RESET}"
      return department if department
    end

    if normalized_name.include?('science')
      department = find_by(dept_name: 'Science')
      puts "#{ORANGE}normalized name match to science, matching department to Science#{RESET}"
      return department if department
    end

    department = where('LOWER(dept_name) = ?', normalized_name)
                 .or(where('aliases::text ILIKE ?', "%#{normalized_name}%"))
                 .first

    puts "Department found: #{department&.dept_name}"
    department ||= Department.create!(
      dept_name: cleaned_name.titleize,
      error_details: "Department #{department_name} for #{job_url} not found in existing records",
      resolved: false
    )
    unless department.resolved
      Adjudication.log_error(
        adjudicatable_type: 'Department',
        adjudicatable_id: department.id,
        error_details: "Department #{department_name} for #{job_url} not found in existing records"
      )
    end

    department
  end
end
