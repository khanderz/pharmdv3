# frozen_string_literal: true

RED = "\033[31m"
GREEN = "\033[32m"
BLUE = "\033[34m"
RESET = "\033[0m"
ORANGE = "\033[38;2;255;165;0m"

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

def resolve_locations(row_data, company_name)
  cities = normalize_location_data(row_data['company_cities'])
  states = normalize_location_data(row_data['company_states'])
  countries = normalize_location_data(row_data['company_countries'])

  resolved_countries = resolve_location_hierarchy(countries, 'Country')
  resolved_states = states.flat_map do |state|
    parent_country = resolved_countries.first  
    resolve_location_hierarchy([state], 'State', parent_country)
  end
  resolved_cities = cities.flat_map do |city|
    parent_state = resolved_states.first  
    resolve_location_hierarchy([city], 'City', parent_state)
  end

  [resolved_countries, resolved_states, resolved_cities]
end

def find_company_size(size_range, current_company_size = nil)
  if size_range.to_s.match?(/^\d+$/)
    size = size_range.to_i

    range = CompanySize.all.find do |company_size|
      lower, upper = company_size.size_range.split('-').map(&:to_i)
      upper = Float::INFINITY if company_size.size_range.include?('+')
      size.between?(lower, upper)
    end

    if range
      return current_company_size if current_company_size == range

      range

    else
      puts "#{RED}Invalid numeric company size: '#{size_range}' (No matching range found in CompanySize table)#{RESET}"
      nil
    end
  else
    matching_company_size = CompanySize.find_by(size_range: size_range)

    if matching_company_size
      return current_company_size if current_company_size == matching_company_size

      matching_company_size

    else
      puts "#{RED}Invalid company size: '#{size_range}'#{RESET}"
      nil
    end
  end
end

def find_funding_type(funding_type_name, company_name)
  return nil if funding_type_name.blank?

  funding_type = FundingType.where('LOWER(funding_type_name) = ?', funding_type_name.downcase).first

  unless funding_type
    puts "#{RED}Invalid funding type: '#{funding_type_name}' for company: #{company_name}#{RESET}"
    error_details = "Invalid funding type: '#{funding_type_name}' for company: #{company_name}"
    adj_id = company_name + funding_type_name
    puts "#{RED}Adjudication ID: #{adj_id}#{RESET}"
    Adjudication.log_error(
      adjudicatable_type: 'FundingType',
      adjudicatable_id: adj_id,
      error_details: error_details
    )
  end
  funding_type
end

def find_or_create_company_type(company_type_name, company_name)
  return nil if company_type_name.blank?

  company_type = CompanyType.find_by('LOWER(company_type_code) = ?', company_type_name.downcase)

  unless company_type
    puts "#{RED}Invalid company type: '#{company_type_name}' for company: #{company_name}#{RESET}"
    error_details = "Invalid company type: '#{company_type_name}' for company: #{company_name}"
    adj_id = company_name + company_type_name
    puts "#{RED}Adjudication ID: #{adj_id}#{RESET}"
    Adjudication.log_error(
      adjudicatable_type: 'CompanyType',
      adjudicatable_id: adj_id,
      error_details: error_details
    )
  end

  company_type
end

def update_join_tables(company, locations, domains, specialties)
  changes_made = false

  puts "company: #{company.company_name}"
  puts "locations: #{locations}"
  # puts "domains: #{domains}"
  # puts "specialties: #{specialties}"

  domains = domains.compact.uniq(&:id)
  specialties = specialties.compact.uniq(&:id)

  locations.each do |location|
    existing = CompanyLocation.find_by(company_id: company.id, location_id: location.id)
    unless existing
      CompanyLocation.create!(company_id: company.id, location_id: location.id)
      changes_made = true
    end
  end

  existing_domains = CompanyDomain.where(company_id: company.id).pluck(:healthcare_domain_id).sort
  new_domains = domains.map(&:id).sort
  if existing_domains != new_domains
    CompanyDomain.where(company_id: company.id).destroy_all
    domains.each do |domain|
      CompanyDomain.find_or_create_by!(company_id: company.id, healthcare_domain_id: domain.id)
    end
    changes_made = true
  end

  existing_specialties = CompanySpecialization.where(company_id: company.id).pluck(:company_specialty_id).sort
  new_specialties = specialties.map(&:id).sort
  if existing_specialties != new_specialties
    CompanySpecialization.where(company_id: company.id).destroy_all
    specialties.each do |specialty|
      CompanySpecialization.find_or_create_by!(company_id: company.id,
                                               company_specialty_id: specialty.id)
    end
    changes_made = true
  end

  changes_made
end

def update_existing_company(company, row_data, ats_type, locations, domains,
                            specialties)
  ActiveRecord::Base.transaction do
    changes_made = false
    changed_attributes = {}
    current_company_size = company.company_size
    current_funding_type = company.funding_type
    current_company_type = company.company_type_id

    company_size = find_company_size(row_data['company_size'])
    funding_type = find_funding_type(row_data['last_funding_type'], row_data['company_name'])
    company_type = find_or_create_company_type(row_data['company_type'], row_data['company_name'])

    if company_size && company_size.id != current_company_size&.id
      company.assign_attributes(company_size_id: company_size.id)
    end

    if funding_type && funding_type.id != current_funding_type&.id
      company.assign_attributes(funding_type_id: funding_type.id)
    end

    if company_type && company_type.id != current_company_type
      company.assign_attributes(company_type_id: company_type.id)
    end

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
      puts "Attempting to save company: #{company.company_name} with changes: #{changed_attributes[:company]}"

      company.save!
    end

    join_table_changes = update_join_tables(company, locations, domains, specialties)
    changes_made ||= join_table_changes

    if changes_made
      puts "#{BLUE}Updated #{company.company_name}#{RESET}"
      if changed_attributes[:company]
        puts "#{BLUE}Attribute changes: #{changed_attributes[:company]}#{RESET}"
      end
    else
      puts "#{company.company_name} has no changes."
    end
  rescue ActiveRecord::RecordInvalid => e
    puts "#{RED}Error saving company #{company.company_name}: #{e.message}#{RESET}"
    raise ActiveRecord::Rollback
  end
end

def create_new_company(row_data, ats_type, locations, domains, specialties)
  company_size = find_company_size(row_data['company_size'])
  funding_type = find_funding_type(row_data['last_funding_type'], row_data['company_name'])
  company_type = find_or_create_company_type(row_data['company_type'], row_data['company_name'])

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
    ats_type_id: ats_type&.id,
    company_size_id: company_size&.id,
    funding_type_id: funding_type&.id || nil,
    company_type_id: company_type&.id
  )

  if new_company.save
    update_join_tables(new_company, locations, domains, specialties)
    puts "#{GREEN}Added new company: #{new_company.company_name}.#{RESET}"
  else
    puts "#{RED}Failed to save new company: #{new_company.company_name}. Errors: #{new_company.errors.full_messages.join(', ')}#{RESET}"
  end
end

def process_company_data(row_data, _headers)
  ActiveRecord::Base.transaction do
    company_name = row_data['company_name']
    return unless company_name.present?

    company = Company.find_by(company_name: company_name)
    ats_type = AtsType.find_by(ats_type_code: row_data['company_ats_type'])

    locations = resolve_locations(row_data, company_name)

    domains = (row_data['healthcare_domain'] || '').split(',').map(&:strip).map do |key|
      HealthcareDomain.find_or_create_by!(key: key)
    end

    specialties = (row_data['company_specialty'] || '').split(',').map(&:strip).map do |key|
      CompanySpecialty.find_or_create_by!(key: key)
    end

    if company
      puts "#{GREEN}Company #{company_name} found in existing records.#{RESET}"
      update_existing_company(company, row_data, ats_type, locations, domains,
                              specialties)
    else
      puts "#{RED}Company '#{company_name}' not found in existing records.#{RESET}"
      create_new_company(row_data, ats_type, locations, domains, specialties)
    end
  rescue ActiveRecord::RecordInvalid => e
    puts "#{RED}Transaction failed while processing company data for #{row_data['company_name']}: #{e.message}#{RESET}"
    raise ActiveRecord::Rollback
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
