class JobPostCity < ApplicationRecord
  belongs_to :job_post
  belongs_to :city
end