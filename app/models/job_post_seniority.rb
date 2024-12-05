class JobPostSeniority < ApplicationRecord
  belongs_to :job_post
  belongs_to :job_seniority
end
