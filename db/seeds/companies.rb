# frozen_string_literal: true

credentials_path = ENV['GOOGLE_CREDENTIALS_PATH']
sheet_id = ENV['MASTER_SHEET_ID']
GH_range_name = ENV['GREENHOUSE_SHEET_RANGE']
L_range_name = ENV['LEVER_SHEET_RANGE']

begin
  ActiveRecord::Base.transaction do
    gh_data = GoogleSheetsService.fetch_data(credentials_path, sheet_id, GH_range_name)
    l_data = GoogleSheetsService.fetch_data(credentials_path, sheet_id, L_range_name)

    gh_headers = gh_data.shift.map(&:strip)
    l_headers = l_data.shift.map(&:strip)

    unless gh_headers == l_headers
      raise "Headers mismatch between GREENHOUSE and LEVER sheets."
    end

    combined_data = gh_data + l_data
    headers = gh_headers

    puts "#{Company.count} existing rows in the companies table"

    combined_data.each do |row|
      row_data = Hash[headers.zip(row)]
      puts "Processing row: #{row_data}"
      next unless row_data['company_name']

      company = Company.find_by(company_name: row['company_name'])
      company_name = row_data['company_name']
      ats_type = AtsType.find_by(ats_type_code: row_data['company_ats_type'])
      company_countries = Array(row_data['company_countries']).flat_map do |value|
        value.is_a?(String) ? value.split(',').map(&:strip) : value
      end
      company_states = Array(row_data['company_states']).flat_map do |value|
        value.is_a?(String) ? value.split(',').map(&:strip) : value
      end
      company_cities = Array(row_data['company_cities']).flat_map do |value|
        value.is_a?(String) ? value.split(',').map(&:strip) : value
      end

      countries = company_countries.map do |country_name|
        Country.find_by(country_code: country_name) ||
          Country.find_by(country_name: country_name) ||
          Country.where('? = ANY(aliases)', country_name).first ||
          Country.create!(
            country_code: country_name,
            country_name: country_name,
            error_details: "Country '#{country_name}' not found for Company #{company_name}",
            resolved: false
          ).tap do |new_country|
            Adjudication.create!(
              adjudicatable_type: 'Company',
              adjudicatable_id: new_country.id,
              error_details: "Country '#{country_name}' not found for Company #{company_name}",
              resolved: false
            )
            puts "Country not found for company: #{company_name} or country code/name: #{country_name}. Logged to adjudications."
          end
      end.compact

      states = company_states.map do |state_name|
        State.find_by(state_name: state_name) || State.find_by(state_code: state_name) ||
          puts("State not found for company: #{company_name} or name/code: #{state_name}")
      end.compact

      cities = company_cities.map do |city_name|
        City.find_by(city_name: city_name) || City.where('? = ANY(aliases)', city_name).first ||
          City.create!(
            city_name: city_name,
            error_details: "City '#{city_name}' not found for Company #{company_name}",
            resolved: false
          ).tap do |new_city|
            Adjudication.create!(
              adjudicatable_type: 'Company',
              adjudicatable_id: new_city.id,
              error_details: "City '#{city_name}' not found for Company #{company_name}",
              resolved: false
            )
            puts "City not found for company: #{company_name} or name/alias: #{city_name}. Logged to adjudications."
          end
      end.compact

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
