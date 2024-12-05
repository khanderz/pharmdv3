class SavedJobPost < ApplicationRecord
  belongs_to :user
  belongs_to :job_post
end
