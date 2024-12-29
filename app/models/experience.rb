# frozen_string_literal: true

class Experience < ApplicationRecord
  NUMERIC_WORDS = {
    'one' => 1, 'two' => 2, 'three' => 3, 'four' => 4, 'five' => 5,
    'six' => 6, 'seven' => 7, 'eight' => 8, 'nine' => 9, 'ten' => 10,
    'eleven' => 11, 'twelve' => 12, 'thirteen' => 13, 'fourteen' => 14,
    'fifteen' => 15, 'sixteen' => 16, 'seventeen' => 17, 'eighteen' => 18,
    'nineteen' => 19, 'twenty' => 20
  }

  def self.find_or_create_experience(experience_param, job_post)
    puts "#{BLUE}experience param: #{experience_param}#{RESET}"

    min_years, max_years = extract_years(experience_param)
    puts "#{BLUE}min_years: #{min_years}, max_years: #{max_years}#{RESET}"

    experience = if min_years
                   where('min_years <= ? AND (max_years IS NULL OR max_years > ?)', min_years,
                         min_years).first
                 end
    puts "#{BLUE}experience 1: #{experience}#{RESET}"

    if experience
      puts "#{GREEN}Matched experience '#{experience.experience_name}' for '#{experience_param}'.#{RESET}"
      experience.update!(min_years: min_years, max_years: max_years) if min_years || max_years
    else
      experience = where('LOWER(experience_name) = ?', experience_param.downcase)
                   .or(where('LOWER(experience_code) = ?', experience_param.downcase))
                   .first

      puts "#{BLUE}experience 2: #{experience}#{RESET}"

      if experience
        puts "#{BLUE}experience 3: #{experience}#{RESET}"
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
    words_to_numbers!(input)
    plus_match = input.match(/(\d+)\s*(?:\+|and up|or more|years\+|more than)/i)
    return [plus_match[1].to_i, nil] if plus_match
    range_match = input.match(/(?:between|from)?\s*(\d+)\s*(?:-|to|and|–|—)\s*(\d+)\s*years?/i)
    return [range_match[1].to_i, range_match[2].to_i] if range_match
    possible_years = input.scan(/\b\d+\b/).map(&:to_i)
    return [possible_years.first, possible_years.last] if possible_years.any?
    [nil, nil]
  end

  def self.words_to_numbers!(input)
    NUMERIC_WORDS.each do |word, num|
      input.gsub!(/\b#{word}\b/i, num.to_s)
    end
  end
end
