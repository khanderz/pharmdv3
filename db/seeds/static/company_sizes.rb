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
CompanySize.count

company_sizes.each do |size|
  company_size_record = CompanySize.find_or_initialize_by(size_range: size[:size_range])

  # Only seed new company sizes
  unless company_size_record.persisted?
    company_size_record.save!
    seeded_count += 1
  end
end

total_company_sizes = CompanySize.count

puts "*********** Seeded #{seeded_count} company sizes. Total company sizes in the table: #{total_company_sizes}."
