class JobPostLocation < ApplicationRecord
  belongs_to :job_post
  belongs_to :location
end
