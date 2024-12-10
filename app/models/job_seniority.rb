# frozen_string_literal: true

class JobSeniority < ApplicationRecord
  def self.find_by_name(name)
    name = name.downcase

    job_seniority = JobSeniority.where('LOWER(job_seniority_label) = ?', name).first

    job_seniority ||= JobSeniority.where('aliases @> ?', "{#{name}}").first

    job_seniority
  end
end
