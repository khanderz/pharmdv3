companies = Company.all

companies.each do |company|
  JobPost.fetch_jobs(company)
end

puts "There are now #{JobPost.count} rows in the JobPost table."
