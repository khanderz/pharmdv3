# db/seeds/job_posts.rb
# frozen_string_literal: true

companies = Company.all

companies.each do |company|
  JobPost.fetch_and_save_jobs(company)
end

puts "There are now #{JobPost.count} rows in the JobPost table."
