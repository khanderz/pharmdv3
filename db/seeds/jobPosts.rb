# jobs = fetchJobs()

companies = Company.all

companies.each do |company|
  if company.company_ats_type == 'LEVER'
    jobs = JobPost.fetch_lever_jobs(company)
  elsif company.company_ats_type == 'GREENHOUSE'
    jobs = fetch_greenhouse_jobs(company)
  end
  

# if lever
#   jobs.each do |row|
#     j = JobPost.new
#     j.job_title = row['text']
#     j.job_description = row['job_description']
#     j.job_url = row['hostedUrl']
#     j.job_location = row['job_location']
#     j.job_dept = row['department']
#     j.job_posted = row['createdAt']
#     j.job_updated = row['updatedAt']
#     j.job_active = row['isActive']
#     j.job_internal_id = row['id']
#     j.job_internal_id_string = row['requisitionId']
#     j.job_salary_min = row['compensation']['min']
#     j.job_salary_max = row['compensation']['max']
#     j.job_salary_range = row['compensation']['range']
#     j.company_id = row['company_id']
  
#     j.save
#     puts "#{j.job_title} for #{j.company_id.company_name} saved"
# end
  
  
# if greenhouse
# end


# else
# end

puts "There are now #{JobPost.count} rows in the JobPost table"
end