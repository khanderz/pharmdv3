# frozen_string_literal: true

# app/mappers/location_mapper.rb

class LocationMapper
  def self.extract_location(job, source = 'greenhouse')
    case source.downcase
    when 'lever'
      extract_from_lever(job)
    when 'greenhouse'
      extract_from_greenhouse(job)
    else
      []
    end
  end

  def match_location(input, job, company, country_input = nil)
    puts "#{BLUE}location input: #{input} country_input: #{country_input} #{RESET}"
    inputs = Array(input).map(&:strip)

    location_type = determine_location_type(inputs)

    inputs.map do |single_input|
      if single_input.empty? || single_input.casecmp?('Remote')
        default_location(location_type)
      else
        process_single_location(single_input, job, company, country_input, location_type)
      end
    end.compact
  end

  private

  def self.extract_from_lever(job)
    [
      job['categories']&.dig('location'),
      *Array(job['categories']&.dig('allLocations')),
      job.dig('location', 'name')
    ].compact.uniq
  end

  def self.extract_from_greenhouse(job)
    if job['offices'].is_a?(Array)
      job['offices'].map { |office| office['location'] }.compact.uniq
    else
      Array(job.dig('location', 'name')).compact
    end
  end

  def determine_location_type(inputs)
    contains_remote = inputs.any? { |location| location.casecmp?('Remote') }
    contains_city = inputs.any? { |location| parse_input(location).first.present? }
    contains_state_or_country = inputs.any? do |location|
      parsed = parse_input(location)
      parsed[1].present? || parsed[2].present?
    end

    if contains_remote && contains_city
      'Hybrid'
    elsif contains_remote && contains_state_or_country
      'Flexible'
    elsif contains_remote
      'Remote'
    else
      'On-Site'
    end
  end

  def default_location(location_type)
    {
      city_name: nil,
      state_name: nil,
      state_code: nil,
      country_name: nil,
      country_code: nil,
      location_type: location_type
    }
  end

  def process_single_location(input, job, company, country_input, location_type)
    city_name, state_name, country_name = parse_input(input)

    city = City.find_or_create_city(city_name, company, job)
    state = State.find_or_create_state(state_name, company, job)

    country_params = determine_country_params(state, country_name, country_input)
    country = Country.find_or_adjudicate_country(
      country_params[:country_code],
      country_params[:country_name],
      company,
      job['job_url']
    )

    {
      city_name: city&.[](:city_name),
      state_name: state&.[](:state_name),
      state_code: state&.[](:state_code),
      country_name: country&.[](:country_name),
      country_code: country&.[](:country_code),
      location_type: location_type
    }
  end

  def determine_country_params(state, country_name, country_input)
    if state
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
  end

  def parse_input(input)
    return find_location(*input) if input.is_a?(Array)
  
    return [nil, nil, nil] if input.blank?
  
    parts = input.split(',').map(&:strip)
  
    case parts.length
    when 3 then find_location(parts[0], parts[1], parts[2])
    when 2 then find_location(parts[0], parts[1])
    when 1 then find_single_location(parts[0])
    else [nil, nil, nil]
    end
  end
  

  def find_location(city_name, state_name = nil, country_name = nil)
    city = City.find_city_only(city_name)
    state = state_name ? State.find_state_only(state_name) : nil
    country = country_name ? Country.find_country_only(nil, country_name) : nil

    [city&.city_name, state&.state_name, country&.country_name]
  end

  def find_single_location(input)
    city = City.find_city_only(input)
    setting = JobSetting.find_setting(input)

    if city
      [city.city_name, nil, nil]
    elsif setting
      [nil, nil, setting.setting_name]
    else
      [nil, nil, nil]
    end
  end
end
