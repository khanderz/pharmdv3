# frozen_string_literal: true

class JobPostSkill < ApplicationRecord
  belongs_to :job_post
  belongs_to :skill, optional: true
end