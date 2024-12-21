# frozen_string_literal: true

class Education < ApplicationRecord
  def self.find_or_create_education(education_param, job_post)
    cleaned_param = clean_education_param(education_param)

    education = where('LOWER(education_name) = ?', cleaned_param.downcase)
                .or(where('LOWER(education_code) = ?', cleaned_param.downcase))
                .first

    if education
      puts "#{GREEN}Education #{education_param} found in existing records.#{RESET}"
    else
      error_details = "Education #{education_param} for #{job_post} not found in existing records"
      education = create!(
        education_name: education_param,
        error_details: error_details,
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'Education',
        adjudicatable_id: education.id,
        error_details: error_details
      )
    end

    education
  end

  def self.clean_education_param(education_param)
    normalized_param = education_param.to_s
                                      .strip
                                      .downcase
                                      .gsub(/[’‘]/, "'")
                                      .gsub(/[^a-z0-9\s']/i, '')

    degree_code_matches = Education.pluck(:education_code).map(&:downcase)
                                   .select { |code| normalized_param.include?(code) }

    degree_name_matches = Education.pluck(:education_name).map(&:downcase)
                                   .select { |name| normalized_param.include?(name) }

    matches = (degree_code_matches + degree_name_matches).uniq

    prioritized_matches = matches.select do |match|
      %w[postdoc fellowship residency].include?(match)
    end
    return prioritized_matches.first.split.map(&:capitalize).join(' ') if prioritized_matches.any?

    matches.first&.split&.map(&:capitalize)&.join(' ') || education_param.strip
  end
end
