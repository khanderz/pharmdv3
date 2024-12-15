# frozen_string_literal: true

class City < ApplicationRecord
  def self.find_city(city_param, job_post, company)
    city = where('LOWER(city_name) = ? OR LOWER(aliases::text) LIKE ?',
                 city_param.downcase, "%#{city_param.downcase}%").first

    error_message = "City '#{city_param}' not found for #{company.company_name} for job #{job_post.job_title}"
    Adjudication.log_error(
      adjudicatable_type: 'JobPost',
      adjudicatable_id: job_post.id,
      error_details: error_message
    ) if city.nil?

    city
  end
end
