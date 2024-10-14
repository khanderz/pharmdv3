require 'csv' unless defined?(::CSV)

begin
  ActiveRecord::Base.transaction do
    companies_csv = File.read(Rails.root.join('lib', 'seeds', 'companies_test.csv'))
    companies = CSV.parse(companies_csv, headers: true, encoding: 'ISO-8859-1')

    puts "#{Company.count} existing rows in the companies table"

    companies.each do |row|
      company = Company.find_or_initialize_by(company_name: row['company_name'])

      # Assign other attributes
      company.assign_attributes(
        operating_status: row['operating_status'] == 'TRUE',
        linkedin_url: row['linkedin_url'],
        is_public: row['is_public'] == 'TRUE',
        year_founded: row['year_founded'],
        acquired_by: row['acquired_by'],
        ats_id: row['ats_id']
      )

      # Set the AtsType
      ats_type = AtsType.find_by(ats_type_code: row['company_ats_type'])
      if ats_type
        company.ats_type = ats_type
      else
        puts "ATS type not found for code: #{row['company_ats_type']}"
        next
      end

      # Set the CompanySize
      company_size = CompanySize.find_by(size_range: row['company_size'])
      if company_size
        company.company_size = company_size
      else
        puts "Company size not found for range: #{row['company_size']}"
        next
      end

      # Set the FundingType
      funding_type = FundingType.find_by(funding_type_name: row['last_funding_type'])
      if funding_type
        company.funding_type = funding_type
      else
        puts "Funding type not found for name: #{row['last_funding_type']}"
        next
      end

      # Set the Country, State, and City
      country = Country.find_by(country_code: row['company_country'])
      if country
        company.country = country
      else
        puts "Country not found for code: #{row['company_country']}"
        next
      end

      state = State.find_by(state_name: row['company_state'])
      if state
        company.state = state
      else
        puts "State not found for name: #{row['company_state']}"
        next
      end

      city = City.find_by(city_name: row['company_city'])
      if city
        company.city = city
      else
        puts "City not found for name: #{row['company_city']}"
        next
      end

      # Set the company_type (healthcare domain)
      healthcare_domain = HealthcareDomain.find_by(key: row['company_type'])
      if healthcare_domain
        company.company_type = healthcare_domain
      else
        puts "Healthcare domain not found for key: #{row['company_type']}"
        next
      end

      # Assign specialties
      if row['company_specialty'].present?
        specialties = row['company_specialty'].split(',').map do |specialty_key|
          specialty = CompanySpecialty.find_by(key: specialty_key.strip, healthcare_domain_id: healthcare_domain.id)
          if specialty
            specialty
          else
            puts "Specialty #{specialty_key.strip} not valid for healthcare domain #{healthcare_domain.key}"
            nil
          end
        end.compact
        company.company_specialties = specialties
      end

      # Save the company and print a message if updated
      if company.changed?
        company.save
        puts "Updated #{company.company_name} with changes: #{company.changes.keys.join(', ')}"
      else
        puts "#{company.company_name} has no changes"
      end
    end

    puts "There are now #{Company.count} rows in the companies table"
  end
rescue StandardError => e
  puts "Error: #{e.message}"
  raise ActiveRecord::Rollback
end