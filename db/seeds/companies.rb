require 'csv'

# drop_table :companies if ActiveRecord::Base.connection.table_exists? :companies

begin
  ActiveRecord::Base.transaction do
    companies_csv = File.read(Rails.root.join('lib', 'seeds', 'companies_test.csv'))
    companies = CSV.parse(companies_csv, headers: true, encoding: 'ISO-8859-1')

    puts "#{Company.count} existing rows in the companies table"

    companies.each do |row|
      # puts "row: #{row.inspect}"
      c = Company.new
      c.company_name = row['company_name']
      c.operating_status = row['operating_status']

      # Find the corresponding company type
      company_type = CompanyType.find_by(key: row['company_type'])
      c.company_type = company_type if company_type

      # Find the corresponding company specialties
      if row['company_specialty']
        specialties = row['company_specialty'].split(',').map do |specialty_key|
          CompanySpecialty.find_by(key: specialty_key.strip)
        end
        c.company_specialties << specialties.compact if specialties.present?
      end

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
      puts "#{c.company_name} saved"
      # else
      #   puts "#{c.company_name} not saved - validation failed: #{c.errors.full_messages.join(', ')}"
      # end
    end

    puts "There are now #{Company.count} rows in the companies table"
  end
rescue StandardError => e
  puts "Error: #{e.message}"
  raise ActiveRecord::Rollback
end
