# frozen_string_literal: true

class City < ApplicationRecord
  def self.find_or_create_city(city_param, job_post)
    city = where('LOWER(city_name) = ? OR LOWER(aliases::text) LIKE ?',
                 city_param.downcase, "%#{city_param.downcase}%").first

    if city
      puts "#{GREEN}City #{city_param} found in existing records.#{RESET}"
    else
      error_message = "City '#{city_param}' not found for job #{job_post.job_title}"

      city = create!(
        city_name: city_param,
        error_details: error_message,
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'JobPost',
        adjudicatable_id: city.id,
        error_details: error_message
      )
    end

    city
  end
end
