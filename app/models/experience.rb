# frozen_string_literal: true

class Experience < ApplicationRecord
  def self.find_or_create_experience(experience_param, job_post)
    experience = where('LOWER(experience_name) = ?', experience_param.downcase).first

    if experience
      puts "#{GREEN}Experience #{experience_param} found in existing records.#{RESET}"
    else
      error_details = "Experience #{experience_param} for #{job_post.job_url} not found in existing records"
      experience = create!(
        experience_name: experience_param,
        error_details: error_details,
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'JobPost',
        adjudicatable_id: experience.id,
        error_details: error_details
      )
    end

    experience
  end
end
