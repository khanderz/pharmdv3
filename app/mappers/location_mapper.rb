# frozen_string_literal: true

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
    return [default_location('Remote')] if input.is_a?(Array) && input.empty?

    inputs = Array(input).map(&:strip)

    processed_locations = inputs.map do |single_input|
      process_single_location(single_input, job, company, country_input)
    end.compact

    if processed_locations.any? { |location| location.values.any? }
      processed_locations.reject { |location| location.values.all?(&:nil?) }
    else
      processed_locations
    end
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
      job['offices'].map do |office|
        extract_remote_or_name(office)
      end.compact.uniq
    else
      Array(job.dig('location', 'name')).compact
    end
  end

  def self.extract_remote_or_name(office)
    location = office['location']
    name = office['name']
    return 'Remote' if location.nil? && name&.downcase&.include?('remote')

    location || name
  end

  def determine_location_type(city_name, state_name, country_name, job_setting)
    contains_remote = job_setting == 'Remote' || city_name.to_s.casecmp('remote').zero?
    contains_city = city_name.present?
    contains_state_or_country = state_name.present? || country_name.present?

    if contains_remote && contains_city
      'Hybrid'
    elsif contains_remote && contains_state_or_country
      'Flexible'
    elsif contains_remote
      'Remote'
    elsif contains_city && !contains_remote
      'On-site'
    else
      job_setting
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

  def process_single_location(input, job, company, country_input)
    return default_location('Remote') if input.casecmp?('Remote')

    city_name, state_name, country_name, job_setting = parse_input(input)

    country = if country_name.present?
                Location.find_or_create_by_name_and_type(
                  country_name || country_input, company, 'Country', nil, job
                )
              end
    state = if state_name.present?
              Location.find_or_create_by_name_and_type(state_name, company,
                                                       'State', country, job)
            end
    city = if city_name.present?
             Location.find_or_create_by_name_and_type(city_name, company,
                                                      'City', state || country, job)
           end

    job_setting ||= JobSetting.find_setting(input)&.setting_name

    location_type = determine_location_type(city_name, state_name, country_name, job_setting)

    {
      city_name: city&.name,
      state_name: state&.name,
      state_code: state&.code,
      country_name: country&.name,
      country_code: country&.code,
      location_type: location_type
    }
  end

  def parse_input(input)
    return [nil, nil, nil, nil] if input.blank?

    parts = input.split(',').map(&:strip)

    case parts.length
    when 3 then find_location(parts[0], parts[1], parts[2])
    when 2 then find_location(parts[0], parts[1])
    when 1 then find_single_location(parts[0])
    else [nil, nil, nil, nil]
    end
  end

  def find_location(city_name, state_name = nil, country_name = nil)
    country = country_name ? Location.find_by_name_and_type(country_name, 'Country') : nil
    state = state_name ? Location.find_by_name_and_type(state_name, 'State', country) : nil
    city = city_name ? Location.find_by_name_and_type(city_name, 'City', state) : nil
    setting = JobSetting.find_setting(city_name)

    [city&.name, state&.name, country&.name, setting&.setting_name]
  end

  def find_single_location(input)
    return [nil, nil, nil, nil] if input.blank?

    country = Location.find_by_name_and_type(input, 'Country')
    state = Location.find_by_name_and_type(input, 'State', country)
    city = Location.find_by_name_and_type(input, 'City', state)
    setting = JobSetting.find_setting(input)

    if city
      [city.name, nil, nil, nil]
    elsif state
      [nil, state.name, nil, nil]
    elsif country
      [nil, nil, country.name, nil]
    elsif setting
      [nil, nil, nil, setting.setting_name]
    else
      [nil, nil, nil, nil]
    end
  end
end
