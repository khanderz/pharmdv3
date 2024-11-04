# frozen_string_literal: true

# companies = Company.all
companies = Company.where(ats_type: AtsType.find_by(ats_type_code: 'LEVER'))

companies.each do |company|
  JobPost.send(:fetch_jobs, company)
end

puts "There are now #{JobPost.count} rows in the JobPost table."
