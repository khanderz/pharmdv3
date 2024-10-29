# frozen_string_literal: true

require 'csv' unless defined?(::CSV)

begin
  ActiveRecord::Base.transaction do
    companies_csv = File.read(Rails.root.join('lib', 'seeds', 'companies_test.csv'))
    companies = CSV.parse(companies_csv, headers: true, encoding: 'ISO-8859-1')

    puts "#{Company.count} existing rows in the companies table"

    companies.each do |row|
      company = Company.find_by(company_name: row['company_name'])
      ats_type = AtsType.find_by(ats_type_code: row['company_ats_type'])

      country_names = row['company_country'].split(',').map(&:strip)
      countries = country_names.map do |country_name|
        Country.find_by(country_code: country_name) ||
          Country.find_by(country_name: country_name) ||
          Country.where('? = ANY(aliases)', country_name).first ||
          Country.create!(
            country_code: country_name,
            country_name: country_name,
            error_details: "Country '#{country_name}' not found for Company #{row['company_name']}",
            resolved: false
          ).tap do |new_country|
            Adjudication.create!(
              adjudicatable_type: 'Company',
              adjudicatable_id: new_country.id,
              error_details: "Country '#{country_name}' not found for Company #{row['company_name']}",
              resolved: false
            )
            puts "Country not found for company: #{row['company_name']} or country code/name: #{country_name}. Logged to adjudications."
          end
      end.compact

      states = []
      if row['company_state'].present?
        state_names = row['company_state'].split(',').map(&:strip)
        states = state_names.map do |state_name|
          State.find_by(state_name: state_name) || State.find_by(state_code: state_name) ||
            puts("State not found for company: #{row['company_name']} or name/code: #{state_name}")
        end.compact
      end

      city_names = row['company_city']&.split(',')&.map(&:strip) || []
      cities = city_names.map do |city_name|
        City.find_by(city_name: city_name) || City.where('? = ANY(aliases)', city_name).first ||
          City.create!(
            city_name: city_name,
            error_details: "City '#{city_name}' not found for Company #{row['company_name']}",
            resolved: false
          ).tap do |new_city|
            Adjudication.create!(
              adjudicatable_type: 'Company',
              adjudicatable_id: new_city.id,
              error_details: "City '#{city_name}' not found for Company #{row['company_name']}",
              resolved: false
            )
            puts "City not found for company: #{row['company_name']} or name/alias: #{city_name}. Logged to adjudications."
          end
      end.compact

      if company
        puts "-----UPDATING #{row['company_name']}"
        changes_made = Company.seed_existing_companies(company, row, ats_type, countries, states,
                                                       cities)

        if changes_made
          company.save!
          puts "Updated #{company.company_name} with changes."
        else
          puts "#{company.company_name} has no changes."
        end
      else
        puts "-----CREATING #{row['company_name']}"

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

        new_company.countries = countries
        new_company.states = states if states.present?
        new_company.cities = cities if cities.present?

        if ats_type
          new_company.ats_type = ats_type
        else
          puts "ATS type not found for company: #{row['company_name']} or type code: #{row['company_ats_type']}"
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

        new_company.logo_url = row['logo_url'] if row['logo_url'].present?

        new_company.company_url = row['company_url'] if row['company_url'].present?

        # Handle multiple healthcare domains
        healthcare_domains = row['healthcare_domains'].split(',').map(&:strip)
        domains = healthcare_domains.map do |domain_key|
          domain = HealthcareDomain.find_by(key: domain_key)
          if domain.nil?
            puts "Healthcare domain not found for company: #{row['company_name']} or key: #{domain_key}"
          end
          domain
        end.compact

        new_company.healthcare_domains = domains

        # Handle company specialties based on domains
        specialties = row['company_specialty'].split(',').map do |specialty_key|
          specialty = CompanySpecialty.find_by(key: specialty_key.strip)
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
