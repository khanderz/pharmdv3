require 'csv'

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
        company_ats_type: row['company_ats_type'],
        company_size: row['company_size'],
        last_funding_type: row['last_funding_type'],
        linkedin_url: row['linkedin_url'],
        is_public: row['is_public'],
        year_founded: row['year_founded'],
        company_city: row['company_city'],
        company_state: row['company_state'],
        company_country: row['company_country'],
        acquired_by: row['acquired_by'],
        ats_id: row['ats_id']
      )

      # Set the company_type
      company_type = CompanyType.find_by(key: row['company_type'])
      if company_type
        company.company_type = company_type
      else
        puts "Company type not found for key: #{row['company_type']}"
        next
      end

      # Assign specialties
      if row['company_specialty'].present?
        specialties = row['company_specialty'].split(',').map do |specialty_key|
          puts "Processing Specialty Key: #{specialty_key.strip}"  # Debugging output
          specialty = CompanySpecialty.find_by(key: specialty_key.strip)
          if specialty && specialty.company_type == company_type
            specialty
          else
            puts "Specialty #{specialty_key} is not valid for company type #{company_type.key}"
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
