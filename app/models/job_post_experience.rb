# frozen_string_literal: true

class JobPostExperience < ApplicationRecord
  belongs_to :job_post
  belongs_to :experience, optional: true
end