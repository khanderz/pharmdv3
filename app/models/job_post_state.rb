# frozen_string_literal: true

class JobPostState < ApplicationRecord
  belongs_to :job_post
  belongs_to :state
end
