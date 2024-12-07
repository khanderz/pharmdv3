# frozen_string_literal: true

class State < ApplicationRecord
  def self.find_state(state_param, job_post, company)
    state = where('LOWER(state_name) = ? OR LOWER(state_code) = ?', state_param.downcase,
                  state_param.downcase).first

    log_state_error(state_param, job_post, company) if state.nil?

    state
  end

  def self.log_state_error(state_param, job_post, company)
    error_message = "State '#{state_param}' not found for #{company.company_name} for job #{job_post.job_title}"

    Adjudication.create!(
      adjudicatable_type: 'JobPost',
      adjudicatable_id: job_post.id,
      error_details: error_message,
      resolved: false
    )

    puts "Error for #{company.company_name} job post: #{error_message}"
  end
end
