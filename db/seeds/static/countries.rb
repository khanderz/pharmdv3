# Seeding most popular countries for business and startups
countries = [
  { country_code: 'US', country_name: 'United States' },
  { country_code: 'CA', country_name: 'Canada' },
  { country_code: 'GB', country_name: 'United Kingdom' },
  { country_code: 'DE', country_name: 'Germany' },
  { country_code: 'FR', country_name: 'France' },
  { country_code: 'IN', country_name: 'India' },
  { country_code: 'CN', country_name: 'China' },
  { country_code: 'JP', country_name: 'Japan' },
  { country_code: 'KR', country_name: 'South Korea' },
  { country_code: 'AU', country_name: 'Australia' },
  { country_code: 'SG', country_name: 'Singapore' },
  { country_code: 'BR', country_name: 'Brazil' },
  { country_code: 'MX', country_name: 'Mexico' },
  { country_code: 'SE', country_name: 'Sweden' },
  { country_code: 'NL', country_name: 'Netherlands' },
  { country_code: 'IE', country_name: 'Ireland' },
  { country_code: 'CH', country_name: 'Switzerland' },
  { country_code: 'IL', country_name: 'Israel' },
  { country_code: 'ZA', country_name: 'South Africa' },
  { country_code: 'AE', country_name: 'United Arab Emirates' }
]

countries.each do |country|
  begin
    Country.find_or_create_by!(country_code: country[:country_code], country_name: country[:country_name])
  rescue StandardError => e
    puts "Error seeding country: #{country[:country_name]} - #{e.message}"
  end
end

puts "***********Seeded popular countries for business and startups"
