require 'csv'

begin
  ActiveRecord::Base.transaction do
    companies_csv = File.read(Rails.root.join('lib', 'seeds', 'companies_test.csv'))
    companies = CSV.parse(companies_csv, headers: true, encoding: 'ISO-8859-1')

    puts "#{Company.count} existing rows in the companies table"

    companies.each do |row|
      # Find or create the company to avoid duplicates
      c = Company.find_or_create_by(company_name: row['company_name']) do |company|
        company.operating_status = row['operating_status']
        
        # Set the company_type
        company_type = CompanyType.find_by(key: row['company_type'])
        if company_type
          company.company_type = company_type
        else
          puts "Company type not found for key: #{row['company_type']}"
          next # Skip this company if company_type is not found
        end

        # Find the corresponding company specialties and their types
        if row['company_specialty']
          specialties = row['company_specialty'].split(',').map do |specialty_key|
            specialty = CompanySpecialty.find_by(key: specialty_key.strip)
            if specialty && specialty.company_type == company_type
              company.company_specialties << specialty
            else
              puts "Specialty #{specialty_key} is not valid for company type #{company_type.key}"
            end
          end
        end

        # Set other company attributes
        company.company_ats_type = row['company_ats_type']
        company.company_size = row['company_size']
        company.last_funding_type = row['last_funding_type']
        company.linkedin_url = row['linkedin_url']
        company.is_public = row['is_public']
        company.year_founded = row['year_founded']
        company.company_city = row['company_city']
        company.company_state = row['company_state']
        company.company_country = row['company_country']
        company.acquired_by = row['acquired_by']
        company.ats_id = row['ats_id']
      end

      # Output success message after saving the company
      if c.persisted?
        puts "#{c.company_name} saved with specialties: #{c.company_specialties.map(&:key).join(', ')}"
      end
    end

    puts "There are now #{Company.count} rows in the companies table"
  end
rescue StandardError => e
  puts "Error: #{e.message}"
  raise ActiveRecord::Rollback
end
