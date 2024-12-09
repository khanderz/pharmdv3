# frozen_string_literal: true

class Department < ApplicationRecord
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  has_and_belongs_to_many :job_roles, join_table: :job_roles_departments

  validates :dept_name, presence: true, uniqueness: true

  def self.find_department(department_name, adjudicatable_type, relation = nil)
    department = Department.find_by('LOWER(dept_name) = ? OR LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                                    department_name.downcase, department_name.downcase)
    if department
      puts "#{GREEN}Department #{department_name} found in existing records.#{RESET}"
    else
      department = Department.create!(
        dept_name: department_name,
        error_details: "Department #{department_name} for #{relation} not found in existing records",
        resolved: false
      )
      Adjudication.create!(
        adjudicatable_type: adjudicatable_type,
        adjudicatable_id: department.id,
        error_details: "Department #{department_name} for #{relation} not found in existing records",
        resolved: false
      )
      puts "#{RED}Department #{department_name} created and logged to adjudications with adjudicatable_type #{adjudicatable_type}.#{RESET}"
    end
    department
  end
end
