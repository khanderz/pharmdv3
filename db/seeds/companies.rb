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
        operating_status: row['operating_status'],
        linkedin_url: row['linkedin_url'],
        is_public: row['is_public'],
        year_founded: row['year_founded'],
        acquired_by: row['acquired_by']
      )

      # Set the AtsType
      ats_type = AtsType.find_by(ats_type_code: row['company_ats_type'])
      if ats_type
        company.ats_type = ats_type
      else
        puts "ATS type not found for company: #{row['company_name']} or type code: #{row['company_ats_type']}"
        next
      end

      # Optional attributes: Set only if present in the CSV row
      if row['company_size'].present?
        company_size = CompanySize.find_by(size_range: row['company_size'])
        company.company_size = company_size if company_size
      end

      if row['last_funding_type'].present?
        funding_type = FundingType.find_by(funding_type_name: row['last_funding_type'])
        company.funding_type = funding_type if funding_type
      end

      # Set the Country, matching on either country_code or country_name
      country = Country.find_by(country_code: row['company_country']) || Country.find_by(country_name: row['company_country'])
      if country
        company.country = country
      else
        puts "Country not found for company: #{row['company_name']} or country code/name: #{row['company_country']}"
        next
      end

      # Set the State, matching on either state_name or state_code
      if row['company_state'].present?
        state = State.find_by(state_name: row['company_state']) || State.find_by(state_code: row['company_state'])
        if state
          company.state = state
        else
          puts "State not found for company: #{row['company_name']} or name/code: #{row['company_state']}"
        end
      end

      # Set the City, matching on city_name or aliases
      if row['company_city'].present?
        city = City.find_by(city_name: row['company_city']) || City.find_by("'#{row['company_city']}' = ANY (aliases)")
        if city
          company.city = city
        else
          puts "City not found for company: #{row['company_name']} or name/alias: #{row['company_city']}"
        end
      end

      # Set the healthcare domain
      healthcare_domain = HealthcareDomain.find_by(key: row['healthcare_domain'])
      if healthcare_domain
        company.healthcare_domain = healthcare_domain
      else
        puts "Healthcare domain not found for company: #{row['company_name']} or key: #{row['healthcare_domain']}"
        next
      end

      # Assign specialties if present
      if row['company_specialty'].present?
        specialties = row['company_specialty'].split(',').map do |specialty_key|
          specialty = CompanySpecialty.find_by(key: specialty_key.strip, healthcare_domain_id: healthcare_domain.id)
          specialty
        end.compact
        company.company_specialties = specialties
      end

      # Save the company and print a message if updated
      if company.changed?
        company.save!
        changes = company.changes.keys.join(', ')
        puts changes.present? ? "Updated #{company.company_name} with changes: #{changes}" : "#{company.company_name} has changes, but none worth noting."
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
