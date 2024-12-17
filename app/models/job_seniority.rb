# frozen_string_literal: true

class JobSeniority < ApplicationRecord
  def self.find_or_create_seniority(name, job_post)
    param = name.downcase

    job_seniority = where('LOWER(job_seniority_label) = ?', param)
                    .or(where('LOWER(job_seniority_code) = ?', param))
                    .or(
                      where(
                        'EXISTS (SELECT 1 FROM UNNEST(aliases) AS alias WHERE LOWER(alias) = ?)', param
                      )
                    ).first

    if job_seniority
      puts "#{GREEN}Job Seniority #{name} found in existing records.#{RESET}"
    else
      error_details = "Job Seniority #{name} for #{job_post} not found in existing records"
      job_seniority = JobSeniority.create!(
        job_seniority_label: name,
        error_details: error_details,
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'JobSeniority',
        adjudicatable_id: job_seniority.id,
        error_details: error_details
      )
    end

    job_seniority
  end
end
