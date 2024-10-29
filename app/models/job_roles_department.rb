class JobRolesDepartment < ApplicationRecord
  belongs_to :job_role
  belongs_to :department
end
