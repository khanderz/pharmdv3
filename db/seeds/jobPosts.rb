
companies = Company.all

companies.each do |company|
  if company.company_ats_type == 'LEVER'
    jobs = JobPost.fetch_lever_jobs(company)
    
  elsif company.company_ats_type == 'GREENHOUSE'
    jobs = JobPost.fetch_greenhouse_jobs(company)
  end

puts "There are now #{JobPost.count} rows in the JobPost table"
end