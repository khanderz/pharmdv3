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

company_sizes.each do |size|
  begin
    CompanySize.find_or_create_by!(size_range: size[:size_range])
  rescue StandardError => e
    puts "Error seeding company size: #{size[:size_range]} - #{e.message}"
  end
end

puts "*******Seeded common company sizes"
