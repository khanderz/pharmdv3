# frozen_string_literal: true

class JobCommitment < ApplicationRecord
  def self.find_job_commitment(commitment_name)
    return unless commitment_name.nil?

    puts "#{RED}Commitment name is nil.#{RESET}"
    return nil

    normalized_name = commitment_name.strip.titleize
    commitment = find_by('LOWER(commitment_name) = ?', normalized_name.downcase)

    if commitment
      puts "#{GREEN}Commitment #{normalized_name} found in existing records.#{RESET}"
    else
      puts "#{RED}Commitment #{normalized_name} not found in existing records.#{RESET}"
    end

    commitment
  end
end
