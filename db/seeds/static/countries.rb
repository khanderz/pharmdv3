# Seeding most popular countries for business and startups
countries = [
  { country_code: 'AU', country_name: 'Australia' },
  { country_code: 'BD', country_name: 'Bangladesh' },
  { country_code: 'BR', country_name: 'Brazil' },
  { country_code: 'CA', country_name: 'Canada' },
  { country_code: 'CN', country_name: 'China' },
  { country_code: 'CH', country_name: 'Switzerland' },
  { country_code: 'DE', country_name: 'Germany' },
  { country_code: 'EG', country_name: 'Egypt' },
  { country_code: 'ES', country_name: 'Spain' },
  { country_code: 'FR', country_name: 'France' },
  { country_code: 'GB', country_name: 'United Kingdom', aliases: ['UK', 'Great Britain'] },
  { country_code: 'HK', country_name: 'Hong Kong' },
  { country_code: 'ID', country_name: 'Indonesia' },
  { country_code: 'IE', country_name: 'Ireland' },
  { country_code: 'IL', country_name: 'Israel' },
  { country_code: 'IN', country_name: 'India' },
  { country_code: 'JP', country_name: 'Japan' },
  { country_code: 'KR', country_name: 'South Korea' },
  { country_code: 'MX', country_name: 'Mexico' },
  { country_code: 'MY', country_name: 'Malaysia' },
  { country_code: 'NG', country_name: 'Nigeria' },
  { country_code: 'NL', country_name: 'Netherlands' },
  { country_code: 'PH', country_name: 'Philippines' },
  { country_code: 'PT', country_name: 'Portugal' },
  { country_code: 'RU', country_name: 'Russia' },
  { country_code: 'SA', country_name: 'Saudi Arabia' },
  { country_code: 'SE', country_name: 'Sweden' },
  { country_code: 'SG', country_name: 'Singapore' },
  { country_code: 'TH', country_name: 'Thailand' },
  { country_code: 'TR', country_name: 'Turkey' },
  { country_code: 'AE', country_name: 'United Arab Emirates' },
  { country_code: 'US', country_name: 'United States', aliases: ['USA', 'United States of America'] },
  { country_code: 'VN', country_name: 'Vietnam' },
  { country_code: 'ZA', country_name: 'South Africa' }
]

seeded_count = 0
existing_count = 0
total_countries = Country.count

countries.each do |country|
  begin
    country_record = Country.find_or_initialize_by(country_code: country[:country_code], country_name: country[:country_name])
    
    if country_record.persisted?
      existing_count += 1
    else
      country_record.save!
      seeded_count += 1
    end
  rescue StandardError => e
    puts "Error seeding country: #{country[:country_name]} - #{e.message}"
  end
end

total_countries_after = Country.count

puts "***********Seeded #{seeded_count} new countries. #{existing_count} countries already existed. Total countries in the table: #{total_countries_after}."