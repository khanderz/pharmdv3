class JobPost < ApplicationRecord
  belongs_to :job_commitment
  belongs_to :job_setting
  belongs_to :job_country
  belongs_to :job_location
  belongs_to :job_department
  belongs_to :job_team
  belongs_to :company
  belongs_to :job_role
  belongs_to :job_salary_currency
  belongs_to :job_salary_interval
end
