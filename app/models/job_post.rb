class JobPost < ApplicationRecord
  belongs_to :job_commitment
  belongs_to :job_setting
  belongs_to :country
  belongs_to :department
  belongs_to :team
  belongs_to :company
  belongs_to :job_role
  belongs_to :job_salary_currency
  belongs_to :job_salary_interval
end
