require 'csv' unless defined?(::CSV)

begin
  ActiveRecord::Base.transaction do
    companies_csv = File.read(Rails.root.join('lib', 'seeds', 'companies_test.csv'))
    companies = CSV.parse(companies_csv, headers: true, encoding: 'ISO-8859-1')

    puts "#{Company.count} existing rows in the companies table"

    companies.each do |row|
      company = Company.find_by(company_name: row['company_name'])
      ats_type = AtsType.find_by(ats_type_code: row['company_ats_type'])
      country = Country.find_by(country_code: row['company_country']) ||
                Country.find_by(country_name: row['company_country']) ||
                Country.where('? = ANY(aliases)', row['company_country']).first  

      if company
       puts "-----UPDATING #{row['company_name']}"
        changes_made = Company.seed_existing_companies(company, row, ats_type, country)

        if changes_made
          company.save!
          puts "Updated #{company.company_name} with changes."
        else
          puts "#{company.company_name} has no changes."
        end
      else

        puts "-----CREATING #{row['company_name']}"
        # Create a new company
        new_company = Company.new(
          company_name: row['company_name'],
          operating_status: row['operating_status'],
          linkedin_url: row['linkedin_url'],
          is_public: row['is_public'],
          year_founded: row['year_founded'],
          acquired_by: row['acquired_by'],
          company_description: row['company_description'],
          ats_id: row['ats_id']
        )

        if ats_type
          new_company.ats_type = ats_type
        else
          puts "ATS type not found for company: #{row['company_name']} or type code: #{row['company_ats_type']}"
        end

        if country
          new_company.country = country
        else
          new_country = Country.create!(
            country_code: row['company_country'],
            country_name: row['company_country'],
            error_details: "Country '#{row['company_country']}' not found for Company #{row['company_name']}",
            resolved: false
          )

          Adjudication.create!(
            adjudicatable_type: 'Company',
            adjudicatable_id: new_country.id,
            error_details: "Country '#{row['company_country']}' not found for Company #{row['company_name']}",
            resolved: false
          )

          puts "Country not found for company: #{row['company_name']} or country code/name: #{row['company_country']}. Logged to adjudications."
        end

        if row['company_state'].present?
          state = State.find_by(state_name: row['company_state']) || State.find_by(state_code: row['company_state'])
          if state
            new_company.state = state
          else
            puts "State not found for company: #{row['company_name']} or name/code: #{row['company_state']}"
          end
        end

        if row['company_city'].present?
          city = City.find_by(city_name: row['company_city']) || City.where('? = ANY (aliases)', row['company_city']).first

          if city
            new_company.city = city
          else
            new_city = City.create!(
              city_name: row['company_city'],
              error_details: "City '#{row['company_city']}' not found for Company #{row['company_name']}",
              resolved: false
            )

            Adjudication.create!(
              adjudicatable_type: 'Company',
              adjudicatable_id: new_city.id,
              error_details: "City '#{row['company_city']}' not found for Company #{row['company_name']}",
              resolved: false
            )

            puts "City not found for company: #{row['company_name']} or name/alias: #{row['company_city']}. Logged to adjudications."
          end
        end

        # Optional attributes
        if row['company_size'].present?
          company_size = CompanySize.find_by(size_range: row['company_size'])
          if company_size
            new_company.company_size = company_size
          else
            puts "Company size not found for company: #{row['company_name']} or size: #{row['company_size']}"
          end
        end

        if row['last_funding_type'].present?
          funding_type = FundingType.find_by(funding_type_name: row['last_funding_type'])
          if funding_type
            new_company.funding_type = funding_type
          else
            puts "Funding type not found for company: #{row['company_name']} or type: #{row['last_funding_type']}"
          end
        end

        healthcare_domain = HealthcareDomain.find_by(key: row['healthcare_domain'])
        if healthcare_domain
          new_company.healthcare_domain = healthcare_domain
        else
          puts "Healthcare domain not found for company: #{row['company_name']} or key: #{row['healthcare_domain']}"
        end

        specialties = row['company_specialty'].split(',').map do |specialty_key|
          specialty = CompanySpecialty.find_by(key: specialty_key.strip, healthcare_domain_id: healthcare_domain&.id)
          if specialty.nil?
            puts "Specialty not found for company: #{row['company_name']} or key: #{specialty_key.strip}"
            nil
          else
            specialty
          end
        end.compact

        new_company.company_specialties = specialties

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
