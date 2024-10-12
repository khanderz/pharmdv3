# Load company_types and company_specialties first
load File.join(Rails.root, "db", "seeds", "company_types.rb")
load File.join(Rails.root, "db", "seeds", "company_specialties.rb")

# Then load other seed files
Dir[File.join(Rails.root, "db", "seeds", "*.rb")].sort.each do |seed|
  next if seed.include?("company_types.rb") || seed.include?("company_specialties.rb") # Skip already loaded seeds

  puts "seeding - #{seed}. loading seeds"
  load seed
end
