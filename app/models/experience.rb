# frozen_string_literal: true

class Experience < ApplicationRecord
  def self.find_or_create_experience(experience_param, job_post)
    min_years, max_years = extract_years(experience_param)

    experience = if min_years
                   where('min_years <= ? AND (max_years IS NULL OR max_years > ?)', min_years, min_years).first
                 end

    if experience
      puts "#{GREEN}Matched experience '#{experience.experience_name}' for '#{experience_param}'.#{RESET}"
      experience.update!(min_years: min_years, max_years: max_years) if min_years || max_years
    else
      experience = where('LOWER(experience_name) = ?', experience_param.downcase)
                   .or(where('LOWER(experience_code) = ?', experience_param.downcase))
                   .first

      if experience
        puts "#{GREEN}Experience '#{experience_param}' found in existing records.#{RESET}"
        experience.update!(min_years: min_years, max_years: max_years) if min_years || max_years
      else
        error_details = "Experience '#{experience_param}' for '#{job_post}' not found in existing records"
        experience = create!(
          experience_name: experience_param,
          min_years: min_years,
          max_years: max_years,
          error_details: error_details,
          resolved: false
        )
        Adjudication.log_error(
          adjudicatable_type: 'Experience',
          adjudicatable_id: experience.id,
          error_details: error_details
        )
      end
    end

    experience
  end

  def self.extract_years(input)
    input = input.downcase.strip

    plus_match = input.match(/(\d+)\s*\+?\s*years?/i)
    return [plus_match[1].to_i, nil] if plus_match

    range_match = input.match(/(\d+)\s*-\s*(\d+)\s*years?/i)
    return [range_match[1].to_i, range_match[2].to_i] if range_match

    possible_years = input.scan(/\b\d+\b/).map(&:to_i)
    return [possible_years.first, possible_years.last] if possible_years.any?

    [nil, nil]
  end
end
