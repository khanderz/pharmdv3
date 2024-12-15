# frozen_string_literal: true

class Credential < ApplicationRecord
  def self.find_or_create_credential(credential_param, job_post)
    credential = where('LOWER(credential_name) = ?', credential_param.downcase).first

    if credential
      puts "#{GREEN}Credential #{credential_param} found in existing records.#{RESET}"
    else
      error_details = "Credential #{credential_param} for #{job_post.job_url} not found in existing records"
      credential = create!(
        credential_name: credential_param,
        error_details: error_details,
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'JobPost',
        adjudicatable_id: credential.id,
        error_details: error_details
      )
    end

    credential
  end
end
