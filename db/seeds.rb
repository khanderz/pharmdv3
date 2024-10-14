# Load all static seed data first
Dir[File.join(Rails.root, "db", "seeds", "static", "*.rb")].sort.each do |static_seed|
  puts "Seeding static data - #{static_seed}"
  load static_seed
end

# Load companies and job_posts seed data
load File.join(Rails.root, "db", "seeds", "companies.rb")
load File.join(Rails.root, "db", "seeds", "job_posts.rb")

