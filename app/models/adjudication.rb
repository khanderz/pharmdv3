# frozen_string_literal: true

class Adjudication < ApplicationRecord
  belongs_to :adjudicatable, polymorphic: true

  def self.log_error(adjudicatable_type:, adjudicatable_id:, error_details:, resolved: false)
    create!(
      adjudicatable_type: adjudicatable_type,
      adjudicatable_id: adjudicatable_id,
      error_details: error_details,
      resolved: resolved
    )
    puts "Error logged for #{adjudicatable_type} ID: #{adjudicatable_id} - #{error_details}"
  end

  def self.resolve_error(adjudicatable_type:, adjudicatable_id:, error_details:)
    adjudication = find_by(
      adjudicatable_type: adjudicatable_type,
      adjudicatable_id: adjudicatable_id,
      error_details: error_details
    )

    if adjudication
      adjudication.update!(resolved: true)
      puts "Adjudication resolved for #{adjudicatable_type} ID: #{adjudicatable_id} - #{error_details}"
    else
      puts "No adjudication found for #{adjudicatable_type} ID: #{adjudicatable_id} with error details: #{error_details}"
    end
  end
end
