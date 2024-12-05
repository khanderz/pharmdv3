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

begin
  ActiveRecord::Base.transaction do
    gh_data = GoogleSheetsService.fetch_data(credentials_path, sheet_id, GH_range_name)
    l_data = GoogleSheetsService.fetch_data(credentials_path, sheet_id, L_range_name)

    gh_headers = gh_data.shift.map(&:strip)
    l_headers = l_data.shift.map(&:strip)

    raise 'Headers mismatch between GREENHOUSE and LEVER sheets.' unless gh_headers == l_headers

    combined_data = gh_data + l_data
    headers = gh_headers

    puts "#{Company.count} existing rows in the companies table"

    combined_data.each do |row|
      row_data = Hash[headers.zip(row)]
      # puts "Processing row: #{row_data}"
      next unless row_data['company_name']

      company_name = row_data['company_name']
      company = Company.find_by(company_name: company_name)
      ats_type = AtsType.find_by(ats_type_code: row_data['company_ats_type'])
      company_countries = normalize_location_data(row_data['company_countries'])
      company_states = normalize_location_data(row_data['company_states'])
      company_cities = normalize_location_data(row_data['company_cities'])

      countries = company_countries.map do |country_name|
        existing_country = Country.where(
          'LOWER(country_code) = ? OR LOWER(country_name) = ? OR LOWER(?) = ANY(aliases)',
          country_name.downcase, country_name.downcase, country_name.downcase
        ).first
      
        if existing_country
          puts("Found existing country: #{existing_country.country_name}")
          existing_country
        else
          puts "Creating new country: #{country_name}"
          new_country = Country.create!(
            country_code: country_name,
            country_name: country_name,
            error_details: "Country '#{country_name}' not found for Company #{company_name}",
            resolved: false
          )
          new_country.save!
          puts("new country created: #{new_country.country_name}")
      
          Adjudication.create!(
            adjudicatable_type: 'Country',
            adjudicatable_id: new_country.id,
            error_details: "Country '#{country_name}' not found for Company #{company_name}",
            resolved: false
          )
          puts "Country not found for company: #{company_name} or country code/name: #{country_name}. Logged to adjudications."
          new_country
        end
      end.compact

      countries = resolve_location(countries)      

      states = company_states.map do |state_name|
        State.where('LOWER(state_name) = ? OR LOWER(state_code) = ?', 
                    state_name.downcase, state_name.downcase).first ||
          begin
            puts("State not found for company: #{company_name} or name/code: #{state_name}")
            nil  
          end
      end.compact

      states = resolve_location(states)

      cities = company_cities.map do |city_name|
        puts("city_name: #{city_name}")
        existing_city = City.where(
          'LOWER(city_name) = ? OR LOWER(?) = ANY(aliases)',
          city_name.downcase, city_name.downcase
        ).first
      
        if existing_city
          puts("Found existing city: #{existing_city.city_name}")
          existing_city  
        else
          puts "Creating new city: #{city_name}"
          new_city = City.create!(
            city_name: city_name,
            error_details: "City '#{city_name}' not found for Company #{company_name}",
            resolved: false
          )
          new_city.save!
          puts("new city created: #{new_city.city_name}")
      
          Adjudication.create!(
            adjudicatable_type: 'City',
            adjudicatable_id: new_city.id,
            error_details: "City '#{city_name}' not found for Company #{company_name}",
            resolved: false
          )
          puts "City not found for company: #{company_name} or name/alias: #{city_name}. Logged to adjudications."
          new_city
        end
      end.compact

      cities = resolve_location(cities)
      

      if company
        puts "-----UPDATING #{company_name}"
        changes_made = Company.seed_existing_companies(company, row, ats_type, countries, states,
                                                       cities)

        if changes_made
          company.save!
          puts "Updated #{company.company_name} with changes."
        else
          puts "#{company.company_name} has no changes."
        end
      else
        puts "-----CREATING #{company_name}"

        new_company = Company.new(
          company_name: company_name,
          linkedin_url: row_data['linkedin_url'],
          company_url: row_data['company_url'],
          # is_public: ActiveModel::Type::Boolean.new.cast(row_data['is_public']),
          year_founded: row_data['year_founded'].to_i,
          operating_status: ActiveModel::Type::Boolean.new.cast(row_data['operating_status']),
          acquired_by: row_data['acquired_by'],
          ats_id: row_data['ats_id'],
          logo_url: row_data['logo_url'],
          company_description: row_data['company_description'],
          company_tagline: row_data['company_tagline']
        )

        new_company.countries = countries
        new_company.states = states if states.present?
        new_company.cities = cities if cities.present?
        new_company.ats_type = ats_type if ats_type

        # Optional attributes
        if row_data['company_size'].present?
          company_size = CompanySize.find_by(size_range: row_data['company_size'])
          new_company.company_size = company_size if company_size
        end

        if row_data['last_funding_type'].present?
          funding_type = FundingType.find_by(funding_type_name: row_data['last_funding_type'])
          new_company.funding_type = funding_type if funding_type
        end

        # Handle multiple healthcare domains
        healthcare_domains = row_data['healthcare_domains']&.split(',')&.map(&:strip) || []
        domains = healthcare_domains.map do |domain_key|
          HealthcareDomain.find_by(key: domain_key)
        end.compact
        new_company.healthcare_domains = domains

        # Handle company specialties based on domains
        specialties = row_data['company_specialty']&.split(',')&.map(&:strip) || []
        specialties_mapped = specialties.map do |specialty_key|
          CompanySpecialty.find_by(key: specialty_key)
        end.compact
        new_company.company_specialties = specialties_mapped

        if new_company.save
          puts "Added new company: #{new_company.company_name}."
        else
          puts "Failed to save new company: #{new_company.company_name}. Errors: #{new_company.errors.full_messages.join(', ')}"
        end
      end
    end

    puts "There are now #{Company.count} rows in the companies table."
  end
rescue StandardError => e
  puts "Error: #{e.message}"
  raise ActiveRecord::Rollback
end
