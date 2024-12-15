# frozen_string_literal: true

class State < ApplicationRecord
  def self.find_or_create_state(state_param, job_post)
    state = where('LOWER(state_name) = ? OR LOWER(state_code) = ?', state_param.downcase,
                  state_param.downcase).first

    if state
      puts "#{GREEN}State #{state_param} found in existing records.#{RESET}"
    else
      error_details = "State #{state_param} for #{job_post.job_url} not found in existing records"

      state = create!(
        state_name: state_param,
        error_details: error_details,
        resolved: false
      )

      Adjudication.log_error(
        adjudicatable_type: 'JobPost',
        adjudicatable_id: state.id,
        error_details: error_details
      )
    end

    state
  end
end
