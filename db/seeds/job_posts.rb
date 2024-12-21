# db/seeds/job_posts.rb
# frozen_string_literal: true

validation_flag = ENV['VALIDATION'] == 'true'

companies = Company.all

companies.each do |company|
  JobPost.fetch_and_save_jobs(company, use_validation: validation_flag)
end

puts "There are now #{JobPost.count} rows in the JobPost table."
