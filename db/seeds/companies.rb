# frozen_string_literal: true

RED = "\033[31m"
GREEN = "\033[32m"
BLUE = "\033[34m"
RESET = "\033[0m"

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
  changes_made = false

  countries = countries.uniq { |country| country.id }
  states = states.uniq { |state| state.id }
  cities = cities.uniq { |city| city.id }
  domains = domains.uniq { |domain| domain.id }
  specialties = specialties.uniq { |specialty| specialty.id }

  existing_countries = CompanyCountry.where(company_id: company.id).pluck(:country_id).sort
  new_countries = countries.map(&:id).sort
  if existing_countries != new_countries
    CompanyCountry.where(company_id: company.id).destroy_all
    countries.each do |country|
      CompanyCountry.create!(company_id: company.id, country_id: country.id)
    end
    changes_made = true
  end

  existing_states = CompanyState.where(company_id: company.id).pluck(:state_id).sort
  new_states = states.map(&:id).sort
  if existing_states != new_states
    CompanyState.where(company_id: company.id).destroy_all
    states.each do |state|
      CompanyState.create!(company_id: company.id, state_id: state.id)
    end
    changes_made = true
  end

  existing_cities = CompanyCity.where(company_id: company.id).pluck(:city_id).sort
  new_cities = cities.map(&:id).sort
  if existing_cities != new_cities
    CompanyCity.where(company_id: company.id).destroy_all
    cities.each do |city|
      CompanyCity.create!(company_id: company.id, city_id: city.id)
    end
    changes_made = true
  end

  existing_domains = CompanyDomain.where(company_id: company.id).pluck(:healthcare_domain_id).sort
  new_domains = domains.map(&:id).sort
  if existing_domains != new_domains
    CompanyDomain.where(company_id: company.id).destroy_all
    domains.each do |domain|
      CompanyDomain.create!(company_id: company.id, healthcare_domain_id: domain.id)
    end
    changes_made = true
  end

  existing_specialties = CompanySpecialization.where(company_id: company.id).pluck(:company_specialty_id).sort
  new_specialties = specialties.map(&:id).sort
  if existing_specialties != new_specialties
    CompanySpecialization.where(company_id: company.id).destroy_all
    specialties.each do |specialty|
      CompanySpecialization.create!(company_id: company.id, company_specialty_id: specialty.id)
    end
    changes_made = true
  end

  changes_made
end

def update_existing_company(company, row_data, ats_type, countries, states, cities, domains, specialties)
  changes_made = false
  changed_attributes = {}

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
    changed_attributes[:company] = company.changes
    company.save!
  end

  join_table_changes = update_join_tables(company, countries, states, cities, domains, specialties)
  changes_made ||= join_table_changes

  if changes_made
    if changed_attributes[:company]
      puts "#{BLUE}Attribute changes for #{company.company_name}: #{changed_attributes[:company]}#{RESET}"
    end

    if join_table_changes
      puts "#{BLUE}Join table changes made for #{company.company_name}#{RESET}"
    end

  else
    puts "#{RED}#{company.company_name} has no changes.#{RESET}"
  end
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

  domains = (row_data['healthcare_domain'] || '').split(',').map(&:strip).map do |key|
    HealthcareDomain.find_or_create_by!(key: key)
  end

  specialties = (row_data['company_specialty'] || '').split(',').map(&:strip).map do |key|
    CompanySpecialty.find_or_create_by!(key: key)
  end

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
