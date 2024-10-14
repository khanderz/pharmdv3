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

  validates :job_title, presence: true
  validates :job_url, uniqueness: true
  validates :job_salary_min, :job_salary_max, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
