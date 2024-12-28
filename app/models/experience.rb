# frozen_string_literal: true

class Experience < ApplicationRecord
  def self.find_or_create_experience(experience_param, job_post)
    min_years, max_years = extract_years(experience_param)

    experience = if min_years
                   where('min_years <= ? AND (max_years >= ? OR max_years IS NULL)', min_years, min_years).first
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
        if min_years || max_years
          experience.update!(min_years: min_years,
                             max_years: max_years)
        end
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
    years_match = input.match(/(\d+)\s*\+?\s*(?:-\s*(\d+))?\s*years?/i)

    if years_match
      min_years = years_match[1].to_i
      max_years = years_match[2]&.to_i
      max_years ||= nil if input.include?('+')
      [min_years, max_years]
    else
      possible_years = input.scan(/\b\d+\b/)
      if possible_years.any?
        min_years = possible_years.first.to_i
        max_years = possible_years.last.to_i if possible_years.length > 1
        max_years ||= nil
        [min_years, max_years]
      else
        [nil, nil]
      end
    end
  end
end
