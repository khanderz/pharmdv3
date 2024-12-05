class JobPostState < ApplicationRecord
  belongs_to :job_post
  belongs_to :state
end
