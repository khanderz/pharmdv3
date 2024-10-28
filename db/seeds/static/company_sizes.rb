# frozen_string_literal: true

# Seeding common company sizes
company_sizes = [
  { size_range: '1-10' },
  { size_range: '11-50' },
  { size_range: '51-200' },
  { size_range: '201-500' },
  { size_range: '501-1000' },
  { size_range: '1001-5000' },
  { size_range: '5001-10000' },
  { size_range: '10001+' }
]

seeded_count = 0
existing_count = 0
updated_count = 0

company_sizes.each do |size|
  company_size_record = CompanySize.find_or_initialize_by(size_range: size[:size_range])

  if company_size_record.persisted?
    existing_count += 1
    updates_made = false

    # Check for updates in each field
    if company_size_record.some_field != size[:some_field]
      company_size_record.some_field = size[:some_field]
      updates_made = true
      puts "Updated some_field for company size #{size[:size_range]}."
    end

    # Add checks for other fields as needed
    # if company_size_record.other_field != size[:other_field]
    #   company_size_record.other_field = size[:other_field]
    #   updates_made = true
    #   puts "Updated other_field for company size #{size[:size_range]}."
    # end

    if updates_made
      company_size_record.save!
      updated_count += 1
      puts "Company size #{size[:size_range]} updated in database."
    else
      puts "Company size #{size[:size_range]} is already up-to-date."
    end
  else
    # New record to seed
    company_size_record.save!
    seeded_count += 1
    puts "Seeded new company size: #{size[:size_range]}"
  end
end

total_company_sizes = CompanySize.count
puts "*********** Seeded #{seeded_count} new company sizes. #{existing_count} company sizes already existed. #{updated_count} company sizes updated. Total company sizes in the table: #{total_company_sizes}."
