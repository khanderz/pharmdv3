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
      locations = []
      location_input = job['categories']&.dig('location')
      all_locations = job['categories']&.dig('allLocations')
      single_location = job.dig('location', 'name')

      locations << location_input if location_input.present?
      locations += Array(all_locations) if all_locations.present?
      locations << single_location if single_location.present?

      locations.compact.uniq
    when 'greenhouse'
      if job['offices'].is_a?(Array) && job['offices'].any?
        job['offices'].map { |office| office['location'] }.compact.uniq
      else
        Array(job.dig('location', 'name')).compact
      end
    end
  end

  def match_location(input, job, company, country_input = nil)
    inputs = Array(input).map(&:strip)

    contains_remote = inputs.any? { |location| location.casecmp?('Remote') }
    contains_city = inputs.any? { |location| parse_input(location)[0].present? }
    contains_state_or_country = inputs.any? do |location|
      parsed = parse_input(location)
      parsed[1].present? || parsed[2].present?
    end

    puts "contains_remote: #{contains_remote}"
    puts "contains_city: #{contains_city}"
    puts "contains_state_or_country: #{contains_state_or_country}"

    location_type = if contains_remote && contains_city
                      'Hybrid'
                    elsif contains_remote && contains_state_or_country
                      'Flexible'
                    elsif contains_remote
                      'Remote'
                    else
                      'On-Site'
                    end

    matched_locations = inputs.map do |single_input|
      if single_input.empty? || single_input.casecmp?('Remote')
        {
          city_name: nil,
          state_name: nil,
          state_code: nil,
          country_name: nil,
          country_code: nil,
          location_type: location_type || 'Remote'
        }
      else
        process_single_location(single_input, job, company, country_input, location_type)
      end
    end

    puts "matched_locations: #{matched_locations}"
    matched_locations.compact
  end

  private

  def process_single_location(input, job, company, country_input, location_type)
    city_name, state_name, country_name = parse_input(input)

    city = City.find_or_create_city(city_name, company, job)
    state = State.find_or_create_state(state_name, company, job)

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

    country = Country.find_or_adjudicate_country(
      country_params[:country_code],
      country_params[:country_name],
      company,
      job['job_url']
    )

    {
      city_name: city[:city_name],
      state_name: state[:state_name],
      state_code: state[:state_code],
      country_name: country[:country_name],
      country_code: country[:country_code],
      location_type: location_type
    }
  end

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
