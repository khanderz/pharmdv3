# frozen_string_literal: true

class JobPostEducation < ApplicationRecord
  belongs_to :job_post
  belongs_to :education, optional: true
end
