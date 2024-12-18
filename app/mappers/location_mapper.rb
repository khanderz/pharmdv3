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
    if input.nil? || input.strip.empty? || input.strip.casecmp?('Remote')
      return {
        city_name: nil,
        state_name: nil,
        state_code: nil,
        country_name: nil,
        country_code: nil,
        location_type: 'Remote'
      }
    end

    city_name, state_name, country_name = parse_input(input)

    # puts "City: #{city_name}, State: #{state_name}, Country: #{country_name}"
    city = City.find_or_create_city(city_name, company, job)
    return unless city

    # puts "City: #{city}"

    state = State.find_or_create_state(state_name, company, job)
    # puts "State: #{state}"

    country_params = if state
                       if state[:country_code] == 'US' || state[:state_code].match?(/^[A-Z]{2}$/)
                         { country_code: 'US', country_name: 'United States' }
                       elsif state[:country_code] == 'CA' || canadian_provinces.include?(state[:state_code])
                         { country_code: 'CA', country_name: 'Canada' }
                       else
                         { country_code: nil, country_name: country_input }
                       end
                     elsif country_name
                       { country_code: nil, country_name: country_name }
                     else
                       { country_code: nil, country_name: country_input }
                     end
    # puts "Country Params: #{country_params}"

    # handles case where location is just a country
    # if Country.exists?(country_name: input || country_input ) || Country.exists?(aliases: input || country_input)
    #   country = Country.find_or_adjudicate_country(nil, input || country_input, company, job['job_url'])
    #   puts "Country: #{country}"
    #   return {
    #     city_name: nil,
    #     state_name: nil,
    #     state_code: nil,
    #     country_name: country.country_name,
    #     country_code: country.country_code,
    #     location_type: 'Remote'
    #   }
    # end

    country = Country.find_or_adjudicate_country(
      country_params[:country_code],
      country_params[:country_name],
      company,
      job['job_url']
    )
    # puts "Country: #{country}"

    return {
      city_name: nil,
      state_name: nil,
      state_code: nil,
      country_name: country&.country_name,
      country_code: country&.country_code,
      location_type: 'Remote'
    } unless country || city || state

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

    case parts.length
    when 3
      city_name = parts[0]
      state_name = parts[1]
      country_name = parts[2]
      [city_name, state_name, country_name]
    when 2
      city_name = parts[0]
      state_name = parts[1]
      [city_name, state_name, nil]
    end
  end

  def log_location_error(location, job_post, company)
    error_message = "Location '#{location}' not found for #{company.company_name} for job #{job_post.job_title}"

    Adjudication.log_error(
      adjudicatable_type: 'JobPost',
      adjudicatable_id: job_post.id,
      error_details: error_message
    )
  end
end
