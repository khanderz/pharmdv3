# frozen_string_literal: true

class JobPostBenefit < ApplicationRecord
  belongs_to :job_post
  belongs_to :benefit
end
