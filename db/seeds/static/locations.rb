# frozen_string_literal: true

countries = [
  { name: 'United States', code: 'US', type: 'Country' },
  { name: 'Canada', code: 'CA', type: 'Country' },
  { name: 'Australia', code: 'AU', type: 'Country' },
  { name: 'South Korea', code: 'KR', type: 'Country' },
  { name: 'Netherlands', code: 'NL', type: 'Country' },
  { name: 'Spain', code: 'ES', type: 'Country' },
  { name: 'China', code: 'CN', type: 'Country' },
  { name: 'India', code: 'IN', type: 'Country' },
  { name: 'Germany', code: 'DE', type: 'Country' },
  { name: 'United Kingdom', code: 'GB', type: 'Country' },
  { name: 'Ireland', code: 'IE', type: 'Country' },
  { name: 'United Arab Emirates', code: 'AE', type: 'Country' },
  { name: 'Brazil', code: 'BR', type: 'Country' },
  { name: 'Japan', code: 'JP', type: 'Country' },
  { name: 'France', code: 'FR', type: 'Country' }
]

states = [
  { name: 'California', code: 'CA', type: 'State', parent_code: 'US', aliases: ['Calif.', 'Golden State'] },
  { name: 'New York', code: 'NY', type: 'State', parent_code: 'US', aliases: ['NY State'] },
  { name: 'Texas', code: 'TX', type: 'State', parent_code: 'US', aliases: ['Tex.'] },
  { name: 'Ontario', code: 'ON', type: 'State', parent_code: 'CA' },
  { name: 'Victoria', code: 'VIC', type: 'State', parent_code: 'AU' },
  { name: 'Seoul', code: '서울특별시', type: 'State', parent_code: 'KR', aliases: ['Seoul-si'] }
]

cities = [
  { name: 'San Francisco', type: 'City', parent_code: 'CA', aliases: ['SF', 'Frisco'] },
  { name: 'New York City', type: 'City', parent_code: 'NY', aliases: ['Manhattan', 'Brooklyn', 'Queens'] },
  { name: 'Austin', type: 'City', parent_code: 'TX', aliases: ['Downtown', 'South Congress'] },
  { name: 'Toronto', type: 'City', parent_code: 'ON', aliases: [] },
  { name: 'Melbourne', type: 'City', parent_code: 'VIC', aliases: ['Melbs'] },
  { name: 'Seoul', type: 'City', parent_code: '서울특별시', aliases: ['Gangnam'] }
]

seeded_count = 0
existing_count = 0
updated_count = 0

def find_parent_id(parent_code, type)
  Location.find_by(code: parent_code, type: type)&.id
end

countries.each do |country|
  location = Location.find_or_initialize_by(code: country[:code], type: country[:type])
  location.name = country[:name]
  location.aliases = country[:aliases] || []
  if location.persisted?
    existing_count += 1
  else
    location.save!
    seeded_count += 1
  end
end

states.each do |state|
  parent_id = find_parent_id(state[:parent_code], 'Country')
  if parent_id
    location = Location.find_or_initialize_by(code: state[:code], type: state[:type])
    location.name = state[:name]
    location.parent_id = parent_id
    location.aliases = state[:aliases] || []
    if location.persisted?
      existing_count += 1
    else
      location.save!
      seeded_count += 1
    end
  else
    puts "Parent country not found for state: #{state[:name]}"
  end
end

cities.each do |city|
  parent_id = find_parent_id(city[:parent_code], 'State')
  if parent_id
    location = Location.find_or_initialize_by(name: city[:name], type: city[:type])
    location.parent_id = parent_id
    location.aliases = city[:aliases] || []
    if location.persisted?
      existing_count += 1
    else
      location.save!
      seeded_count += 1
    end
  else
    puts "Parent state not found for city: #{city[:name]}"
  end
end

puts "Seeded #{seeded_count} new locations. #{existing_count} locations already existed. Total locations: #{Location.count}."
