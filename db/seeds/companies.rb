require 'csv'

# drop_table :companies if ActiveRecord::Base.connection.table_exists? :companies

begin
  ActiveRecord::Base.transaction do
    companies_csv = File.read(Rails.root.join('lib', 'seeds', 'companies_test.csv'))
    companies = CSV.parse(companies_csv, headers: true, encoding: 'ISO-8859-1')

    puts "#{Company.count} existing rows in the companies table"

    companies.each do |row|
      c = Company.new
      c.company_name = row['company_name']
      c.operating_status = row['operating_status']
      
            # Set the company_type first
            company_type = CompanyType.find_by(key: row['company_type'])
            if company_type
              c.company_type = company_type
            else
              puts "Company type not found for key: #{row['company_type']}"
              next # Skip this company if company_type is not found
            end

      # Find the corresponding company specialties and their types
      if row['company_specialty']
        specialties = row['company_specialty'].split(',').map do |specialty_key|
          # Find the company specialty by key
          specialty = CompanySpecialty.find_by(key: specialty_key.strip)
          if specialty && specialty.company_type == company_type
            c.company_specialties << specialty
          else
            puts "Specialty #{specialty_key} is not valid for company type #{company_type.key}"
          end
        end
      end

      # Set other company attributes
      c.company_ats_type = row['company_ats_type']
      c.company_size = row['company_size']
      c.last_funding_type = row['last_funding_type']
      c.linkedin_url = row['linkedin_url']
      c.is_public = row['is_public']
      c.year_founded = row['year_founded']
      c.company_city = row['company_city']
      c.company_state = row['company_state']
      c.company_country = row['company_country']
      c.acquired_by = row['acquired_by']
      c.ats_id = row['ats_id']

      # if c.valid?
      c.save!
      puts "#{c.company_name} saved with specialties: #{c.company_specialties.map(&:key).join(', ')}"
    end

    puts "There are now #{Company.count} rows in the companies table"
  end
rescue StandardError => e
  puts "Error: #{e.message}"
  raise ActiveRecord::Rollback
end
