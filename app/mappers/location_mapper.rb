# frozen_string_literal: true

# app/mappers/location_mapper.rb

class LocationMapper
  # Extracts the location information from a job post.
  #
  # @param job [Hash] The job data containing location details.
  # @param source [String] The source of the job data (e.g., 'lever', 'greenhouse').
  # @return [String, nil] The extracted location or nil if not found.
  def self.extract_location(job, source = 'greenhouse')
    case source.downcase
    when 'lever'
      location_input = job['categories']&.dig('location') || job['categories']&.dig('allLocations') || ''
      location_input.empty? ? nil : location_input
    when 'greenhouse'
      if job['offices'].is_a?(Array) && job['offices'].any?
        job['offices'].first['location']
      else
        job.dig('location', 'name')
      end
    end
  end

  def match_location(input, job, company, country_input = nil)
    if input.strip.casecmp?('Remote')
      return {
        city_name: nil,
        state_name: nil,
        state_code: nil,
        country_name: nil,
        country_code: nil,
        location_type: 'Remote'
      }
    end

    # handles case where location is just a country
    if Country.exists?(country_name: input) || Country.exists?(aliases: input)
      country = Country.find_or_adjudicate_country(nil, input, company.id, job['job_url'])
      return {
        city_name: nil,
        state_name: nil,
        state_code: nil,
        country_name: country.country_name,
        country_code: country.country_code,
        location_type: 'Remote'
      }
    end

    city_name, state_name, country_name = parse_input(input)
    return log_location_error(input, job, company) unless city_name && state_name

    state = State.find_state(state_name, job, company)
    country_params = if state
                       { country_code: 'US', country_name: 'United States' }
                     elsif country_name
                       { country_code: nil, country_name: country_name }
                     else
                       { country_code: nil, country_name: country_input }
                     end

    city = City.find_city(city_name, job, company)
    return unless city

    country = Country.find_or_adjudicate_country(
      country_params[:country_code],
      country_params[:country_name],
      company.id,
      job['job_url']
    )
    return unless country

    {
      city_name: city[:city_name],
      state_name: state[:state_name],
      state_code: state[:state_code],
      country_name: country[:country_name],
      country_code: country[:country_code]
    }
  end

  private

  def parse_input(input)
    parts = input.split(',').map(&:strip)
    return nil if parts.length != 2

    if parts.length == 3
      city_name = parts[0]
      state_name = parts[1]
      country_name = parts[2]
    elsif parts.length == 2
      city_name = parts[0]
      state_name = parts[1]
      country_name = nil
    else
      return nil
    end

    [city_name, state_name, country_name]
  end

  def log_location_error(location, job_post, company)
    error_message = "Location '#{location}' not found for #{company.company_name} for job #{job_post.job_title}"

    Adjudication.create!(
      adjudicatable_type: 'JobPost',
      adjudicatable_id: job_post.id,
      error_details: error_message,
      resolved: false
    )
    puts "Error for #{company.company_name} job post: #{error_message}"
  end
end
