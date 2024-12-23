# frozen_string_literal: true

class City < ApplicationRecord
  def self.find_or_create_city(city_param, company, job_post = nil)
    return nil if city_param.blank?

    city = where('LOWER(city_name) = ?', city_param.downcase)
           .or(
             where('EXISTS (SELECT 1 FROM UNNEST(aliases) AS alias WHERE LOWER(alias) = ?)',
                   city_param.downcase)
           ).first

    unless city
      puts "#{RED}City '#{city_param}' not found for job #{job_post} or company : #{company}.#{RESET}"
      error_message = "City '#{city_param}' not found for job #{job_post} or company : #{company}"
      adj_type = job_post ? 'City' : 'Company'

      new_city = City.create!(
        city_name: city_param,
        error_details: error_message,
        resolved: false
      )

      Adjudication.log_error(
        adjudicatable_type: adj_type,
        adjudicatable_id: new_city.id,
        error_details: error_message
      )
    end

    city
  end

  def self.find_city_only(city_param)
    city = where('LOWER(city_name) = ?', city_param.downcase)
           .or(
             where('EXISTS (SELECT 1 FROM UNNEST(aliases) AS alias WHERE LOWER(alias) = ?)',
                   city_param.downcase)
           ).first

    city || nil
  end
end
