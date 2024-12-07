# frozen_string_literal: true

class City < ApplicationRecord
  def self.find_city(city_param, job_post, company)
    city = where('LOWER(city_name) = ? OR LOWER(aliases::text) LIKE ?',
                 city_param.downcase, "%#{city_param.downcase}%").first

    log_city_error(city_param, job_post, company) if city.nil?

    city
  end

  def self.log_city_error(city_param, job_post, company)
    error_message = "City '#{city_param}' not found for #{company.company_name} for job #{job_post.job_title}"

    Adjudication.create!(
      adjudicatable_type: 'JobPost',
      adjudicatable_id: job_post.id,
      error_details: error_message,
      resolved: false
    )

    puts "Error for #{company.company_name} job post: #{error_message}"
  end
end
