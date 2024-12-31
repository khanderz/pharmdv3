# frozen_string_literal: true

class Credential < ApplicationRecord
  def self.find_or_create_credential(credential_param, job_post)
    puts "credential_param: #{credential_param}"
    normalized_param = credential_param.downcase
    tokens = normalized_param.scan(/\b\w+\b/)
    puts "credential tokens: #{tokens}"

    matching_credentials = where(
      tokens.map do |_|
        'LOWER(credential_name) LIKE ? OR LOWER(credential_code) LIKE ?'
      end.join(' OR '),
      *tokens.flat_map { |token| ["%#{token}%", "%#{token}%"] }
    )

    puts "matching_credentials: #{matching_credentials}"

    if matching_credentials.any?
      puts "#{GREEN}Credentials matched for #{credential_param}: #{matching_credentials.pluck(:credential_name).join(', ')}.#{RESET}"
      return matching_credentials
    end

    error_details = "Credential #{credential_param} for #{job_post} not found in existing records"
    credential = create!(
      credential_name: credential_param,
      error_details: error_details,
      resolved: false
    )
    Adjudication.log_error(
      adjudicatable_type: 'Credential',
      adjudicatable_id: credential.id,
      error_details: error_details
    )
    puts "#{YELLOW}No exact matches found. Created a new credential for #{credential_param}.#{RESET}"
    [credential]
  end
end
