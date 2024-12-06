class JobCommitment < ApplicationRecord
    def self.find_job_commitment(commitment_name)
        return nil if commitment_name.blank?
    
        normalized_name = commitment_name.strip.titleize
        find_by('LOWER(commitment_name) = ?', normalized_name.downcase)
      end
end
