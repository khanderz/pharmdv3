
require 'csv'

companies_csv = File.read(Rails.root.join('lib', 'seeds', 'companies_test.csv'))
# :headers => true option tells the parser to ignore the first line of the CSV file
companies = CSV.parse(companies_csv, :headers => true, :encoding => 'ISO-8859-1')

companies.each do |row|
  c = Company.new
  c.company_name = row['company_name']
  c.operating_status = row['operating_status']
  c.company_type = row['company_type']
  c.company_ats_type = row['company_ats_type']
  c.company_size = row['company_size']
  c.last_funding_type = row['last_funding_type']
  c.linkedin_url = row['linkedin_url']
  c.is_public = row['is_public']
  c.year_founded = row['year_founded']
  c.company_city = row['company_city']
  c.company_country = row['company_country']
  c.acquired_by = row['acquired_by']
  c.ats_id = row['ats_id']
  # creates or updates the record
  c.save
  puts "#{c.company_name} saved"
end

puts "There are now #{Company.count} rows in the companies table"