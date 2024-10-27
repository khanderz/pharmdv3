# frozen_string_literal: true

class JobPostCountry < ApplicationRecord
  belongs_to :job_post
  belongs_to :country
end
