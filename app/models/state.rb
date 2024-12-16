# frozen_string_literal: true

class State < ApplicationRecord
  def self.find_or_create_state(state_param, company, job_post=nil)
    state = where('LOWER(state_name) = ? OR LOWER(state_code) = ?', state_param.downcase,
                  state_param.downcase).first

    unless state
      puts "#{RED}State #{state_param} not found for #{job_post} or company : #{company}.#{RESET}"
      error_details = "State #{state_param} for #{job_post} or company : #{company} not found in existing records"
      adj_type = job_post ? 'State' : 'Company'

      new_state = State.create!(
        state_name: state_param,
        error_details: error_details,
        resolved: false
      )

      Adjudication.log_error(
        adjudicatable_type: adj_type,
        adjudicatable_id: new_state.id,
        error_details: error_details
      )
    end

    state
  end
end
