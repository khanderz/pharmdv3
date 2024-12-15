# frozen_string_literal: true

class Credential < ApplicationRecord
    def self.find_credential(credential_param, job_post, company)
        credential = where('LOWER(credential_name) = ?', credential_param.downcase).first

        error_message = "Credential '#{credential_param}' not found for #{company.company_name} for job #{job_post.job_title}"
        Adjudication.log_error(
            adjudicatable_type: 'JobPost',
            adjudicatable_id: job_post.id,
            error_details: error_message
          ) if credential.nil?

        credential
    end

end
