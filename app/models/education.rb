# frozen_string_literal: true

class Education < ApplicationRecord
  def self.find_or_create_education(education_param, job_post)
    education = where('LOWER(education_name) = ?', education_param.downcase).first

    if education
      puts "#{GREEN}Education #{education_param} found in existing records.#{RESET}"
    else
      error_details = "Education #{education_param} for #{job_post.job_url} not found in existing records"
      education = create!(
        education_name: education_param,
        error_details: error_details,
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'JobPost',
        adjudicatable_id: education.id,
        error_details: error_details
      )
    end

    education
  end
end
