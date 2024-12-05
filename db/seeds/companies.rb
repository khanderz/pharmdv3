# frozen_string_literal: true

credentials_path = ENV['GOOGLE_CREDENTIALS_PATH']
sheet_id = ENV['MASTER_SHEET_ID']
GH_range_name = ENV['GREENHOUSE_SHEET_RANGE']
L_range_name = ENV['LEVER_SHEET_RANGE']

def normalize_location_data(data)
  case data
  when String
    if data.strip.start_with?('[') && data.strip.end_with?(']')
      data = data.gsub(/[\[\]']/, '')
      data.split(',').map(&:strip)
    else
      [data.strip]
    end
  when Array
    data.flatten.map(&:to_s).map(&:strip).compact
  else
    []
  end
end

def resolve_location(locations)
  return nil if locations.empty?
  locations.size == 1 ? locations.first : locations
end

def log_adjudication(entity_type, entity_name, company_name, adjudicatable)
  raise ArgumentError, "Adjudicatable must be persisted" unless adjudicatable.persisted?

  adjudication = Adjudication.create!(
    adjudicatable_type: adjudicatable.class.name,
    adjudicatable_id: adjudicatable.id,
    error_details: "#{entity_type} '#{entity_name}' not found for Company #{company_name}",
    resolved: false
  )

  puts "Logged adjudication for #{entity_type}: #{entity_name}, company: #{company_name}"
  adjudication
rescue ActiveRecord::RecordInvalid => e
  puts "Failed to create adjudication for #{entity_type} '#{entity_name}' and company '#{company_name}': #{e.message}"
  nil
end

def find_or_create_country(country_name, company_name)
  Country.where(
    'LOWER(country_code) = ? OR LOWER(country_name) = ? OR LOWER(?) = ANY(aliases)',
    country_name.downcase, country_name.downcase, country_name.downcase
  ).first || begin
    puts "Creating new country: #{country_name}"
    country = Country.create!(
      country_code: country_name,
      country_name: country_name,
      error_details: "Country '#{country_name}' not found for Company #{company_name}",
      resolved: false
    )
    log_adjudication('Country', country_name, company_name, country)
    country
  end
end

def find_or_create_state(state_name, company_name)
  State.where(
    'LOWER(state_name) = ? OR LOWER(state_code) = ?',
    state_name.downcase, state_name.downcase
  ).first || begin
    puts "State not found for company: #{company_name} or name/code: #{state_name}"
    state = State.create!(
      state_name: state_name,
      error_details: "State '#{state_name}' not found for Company #{company_name}",
      resolved: false
    )
    if state.persisted?
      log_adjudication('State', state_name, company_name, state)
    else
      puts "Failed to persist state: #{state_name}. Adjudication cannot be created."
    end
    state
  end
end

def find_or_create_city(city_name, company_name)
  City.where(
    'LOWER(city_name) = ? OR LOWER(?) = ANY(aliases)',
    city_name.downcase, city_name.downcase
  ).first || begin
    puts "Creating new city: #{city_name}"
    city = City.create!(
      city_name: city_name,
      error_details: "City '#{city_name}' not found for Company #{company_name}",
      resolved: false
    )
    if city.persisted?
      log_adjudication('City', city_name, company_name, city)
    else
      puts "Failed to persist city: #{city_name}. Adjudication cannot be created."
    end
    city
  end
end


def update_join_tables(company, countries, states, cities, domains, specialties)
  countries.each do |country|
    CompanyCountry.find_or_create_by!(company_id: company.id, country_id: country.id)
  end

  states.each do |state|
    CompanyState.find_or_create_by!(company_id: company.id, state_id: state.id)
  end

  cities.each do |city|
    CompanyCity.find_or_create_by!(company_id: company.id, city_id: city.id)
  end

  domains.each do |domain|
    CompanyDomain.find_or_create_by!(company_id: company.id, healthcare_domain_id: domain.id)
  end

  specialties.each do |specialty|
    CompanySpecialization.find_or_create_by!(company_id: company.id, company_specialty_id: specialty.id)
  end
end

def update_existing_company(company, row_data, ats_type, countries, states, cities, domains, specialties)
  changes_made = false

  company.assign_attributes(
    linkedin_url: row_data['linkedin_url'],
    company_url: row_data['company_url'],
    year_founded: row_data['year_founded'].to_i,
    operating_status: ActiveModel::Type::Boolean.new.cast(row_data['operating_status']),
    acquired_by: row_data['acquired_by'],
    ats_id: row_data['ats_id'],
    logo_url: row_data['logo_url'],
    company_description: row_data['company_description'],
    company_tagline: row_data['company_tagline'],
    ats_type: ats_type
  )

  if company.changed?
    changes_made = true
    company.save!
  end

  update_join_tables(company, countries, states, cities, domains, specialties)
  puts changes_made ? "Updated #{company.company_name}" : "#{company.company_name} has no changes."
end

def create_new_company(row_data, ats_type, countries, states, cities, domains, specialties)
  new_company = Company.new(
    company_name: row_data['company_name'],
    linkedin_url: row_data['linkedin_url'],
    company_url: row_data['company_url'],
    year_founded: row_data['year_founded'].to_i,
    operating_status: ActiveModel::Type::Boolean.new.cast(row_data['operating_status']),
    acquired_by: row_data['acquired_by'],
    ats_id: row_data['ats_id'],
    logo_url: row_data['logo_url'],
    company_description: row_data['company_description'],
    company_tagline: row_data['company_tagline'],
    ats_type: ats_type
  )

  if new_company.save
    update_join_tables(new_company, countries, states, cities, domains, specialties)
    puts "Added new company: #{new_company.company_name}."
  else
    puts "Failed to save new company: #{new_company.company_name}. Errors: #{new_company.errors.full_messages.join(', ')}"
  end
end

def process_company_data(row_data, headers)
  company_name = row_data['company_name']
  return unless company_name.present?

  company = Company.find_by(company_name: company_name)
  ats_type = AtsType.find_by(ats_type_code: row_data['company_ats_type'])
  countries = normalize_location_data(row_data['company_countries']).map { |name| find_or_create_country(name, company_name) }
  states = normalize_location_data(row_data['company_states']).map { |name| find_or_create_state(name, company_name) }
  cities = normalize_location_data(row_data['company_cities']).map { |name| find_or_create_city(name, company_name) }
  domains = (row_data['healthcare_domains'] || '').split(',').map(&:strip).map { |key| HealthcareDomain.find_by(key: key) }.compact
  specialties = (row_data['company_specialty'] || '').split(',').map(&:strip).map { |key| CompanySpecialty.find_by(key: key) }.compact

  if company
    update_existing_company(company, row_data, ats_type, countries, states, cities, domains, specialties)
  else
    create_new_company(row_data, ats_type, countries, states, cities, domains, specialties)
  end
end

begin
  ActiveRecord::Base.transaction do
    gh_data = GoogleSheetsService.fetch_data(credentials_path, sheet_id, GH_range_name)
    l_data = GoogleSheetsService.fetch_data(credentials_path, sheet_id, L_range_name)

    gh_headers = gh_data.shift.map(&:strip)
    l_headers = l_data.shift.map(&:strip)

    raise 'Headers mismatch between GREENHOUSE and LEVER sheets.' unless gh_headers == l_headers

    combined_data = gh_data + l_data

    combined_data.each do |row|
      row_data = Hash[gh_headers.zip(row)]
      process_company_data(row_data, gh_headers)
    end

    puts "There are now #{Company.count} rows in the companies table."
  end
rescue StandardError => e
  puts "Error: #{e.message}"
  raise ActiveRecord::Rollback
end
