
class Department < ApplicationRecord
    has_many :job_posts
    has_and_belongs_to_many :job_roles, join_table: :job_roles_departments
    has_many :adjudications, as: :adjudicatable, dependent: :destroy 
    validates :dept_name, presence: true, uniqueness: true
    
    def self.find_department(department_name, adjudicatable_type, relation = nil)
      # Look for the department by its name or aliases (case-insensitive)
      department = Department.find_by('LOWER(dept_name) = ? OR LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))', 
                                      department_name.downcase, department_name.downcase)
      
      if department
        # If the department is found, return it
        department
      else
        # If the department is not found, create a new one and log the adjudication
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
    
        puts "Department #{department_name} created and logged to adjudications with adjudicatable_type #{adjudicatable_type}."
        
        department
      end
    end
    
      
end