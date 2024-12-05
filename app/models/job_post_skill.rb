class JobPostSkill < ApplicationRecord
  belongs_to :job_post
  belongs_to :skill
end
