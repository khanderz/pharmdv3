companies = Company.all

companies.each do |company|
  case company.ats_type.ats_type_code
  when 'LEVER'
    jobs = JobPost.fetch_lever_jobs(company)
    puts "Fetched #{jobs.count} jobs for #{company.company_name} from LEVER."
    
  when 'GREENHOUSE'
    jobs = JobPost.fetch_greenhouse_jobs(company)
    puts "Fetched #{jobs.count} jobs for #{company.company_name} from GREENHOUSE."
    
  else
    puts "ATS type not supported for company: #{company.company_name} (ATS type: #{company.ats_type.ats_type_code})"
  end
end

puts "There are now #{JobPost.count} rows in the JobPost table."
