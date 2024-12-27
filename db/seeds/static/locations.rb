# frozen_string_literal: true

countries = [
  { name: 'Australia', code: 'AU', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Bangladesh', code: 'BD', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Brazil', code: 'BR', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Canada', code: 'CA', type: 'Country', parent_code: nil, aliases: ['Great White North'] },
  { name: 'China', code: 'CN', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Egypt', code: 'EG', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Estonia', code: 'EE', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'France', code: 'FR', type: 'Country', parent_code: nil, aliases: ['République Française'] },
  { name: 'Germany', code: 'DE', type: 'Country', parent_code: nil, aliases: ['Deutschland'] },
  { name: 'Hong Kong', code: 'HK', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'India', code: 'IN', type: 'Country', parent_code: nil, aliases: ['Bharat'] },
  { name: 'Indonesia', code: 'ID', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Ireland', code: 'IE', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Israel', code: 'IL', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Italy', code: 'IT', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Japan', code: 'JP', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Malaysia', code: 'MY', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Mexico', code: 'MX', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Netherlands', code: 'NL', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Nigeria', code: 'NG', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Philippines', code: 'PH', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Portugal', code: 'PT', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Russia', code: 'RU', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Saudi Arabia', code: 'SA', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Singapore', code: 'SG', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'South Africa', code: 'ZA', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'South Korea', code: 'KR', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Spain', code: 'ES', type: 'Country', parent_code: nil, aliases: ['España'] },
  { name: 'Sweden', code: 'SE', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Switzerland', code: 'CH', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Thailand', code: 'TH', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Turkey', code: 'TR', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'United Arab Emirates', code: 'AE', type: 'Country', parent_code: nil, aliases: [] },
  { name: 'United Kingdom', code: 'GB', type: 'Country', parent_code: nil, aliases: ['UK', 'Britain', 'Great Britain'] },
  { name: 'United States', code: 'US', type: 'Country', parent_code: nil, aliases: ['USA', 'America', 'United States of America'] },
  { name: 'Vietnam', code: 'VN', type: 'Country', parent_code: nil, aliases: [] }
]

us_states = [
  { name: 'Alabama', code: 'AL', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Alaska', code: 'AK', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Arizona', code: 'AZ', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Arkansas', code: 'AR', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'California', code: 'CA', type: 'State', parent_code: 'US', aliases: ['Calif.', 'Golden State'] },
  { name: 'Colorado', code: 'CO', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Connecticut', code: 'CT', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Delaware', code: 'DE', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'District of Columbia', code: 'DC', type: 'State', parent_code: 'US', aliases: ['Washington DC', 'Washington D.C.'] },
  { name: 'Florida', code: 'FL', type: 'State', parent_code: 'US', aliases: ['Fla.'] },
  { name: 'Georgia', code: 'GA', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Hawaii', code: 'HI', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Idaho', code: 'ID', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Illinois', code: 'IL', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Indiana', code: 'IN', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Iowa', code: 'IA', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Kansas', code: 'KS', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Kentucky', code: 'KY', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Louisiana', code: 'LA', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Maine', code: 'ME', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Maryland', code: 'MD', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Massachusetts', code: 'MA', type: 'State', parent_code: 'US', aliases: ['Mass.'] },
  { name: 'Michigan', code: 'MI', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Minnesota', code: 'MN', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Mississippi', code: 'MS', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Missouri', code: 'MO', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Montana', code: 'MT', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Nebraska', code: 'NE', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Nevada', code: 'NV', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'New Hampshire', code: 'NH', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'New Jersey', code: 'NJ', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'New Mexico', code: 'NM', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'New York', code: 'NY', type: 'State', parent_code: 'US', aliases: ['NY State'] },
  { name: 'North Carolina', code: 'NC', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'North Dakota', code: 'ND', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Ohio', code: 'OH', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Oklahoma', code: 'OK', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Oregon', code: 'OR', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Pennsylvania', code: 'PA', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Rhode Island', code: 'RI', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'South Carolina', code: 'SC', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'South Dakota', code: 'SD', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Tennessee', code: 'TN', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Texas', code: 'TX', type: 'State', parent_code: 'US', aliases: ['Tex.'] },
  { name: 'Utah', code: 'UT', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Vermont', code: 'VT', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Virginia', code: 'VA', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Washington', code: 'WA', type: 'State', parent_code: 'US', aliases: ['Wash.'] },
  { name: 'West Virginia', code: 'WV', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Wisconsin', code: 'WI', type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Wyoming', code: 'WY', type: 'State', parent_code: 'US', aliases: [] },
]

canadian_provinces = [
  { name: 'Alberta', code: 'AB', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'British Columbia', code: 'BC', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Manitoba', code: 'MB', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'New Brunswick', code: 'NB', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Newfoundland and Labrador', code: 'NL', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Nova Scotia', code: 'NS', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Ontario', code: 'ON', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Prince Edward Island', code: 'PE', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Quebec', code: 'QC', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Saskatchewan', code: 'SK', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Northwest Territories', code: 'NT', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Nunavut', code: 'NU', type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Yukon', code: 'YT', type: 'State', parent_code: 'CA', aliases: [] },
]

australian_states = [
  { name: 'Australian Capital Territory', code: 'ACT', type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'New South Wales', code: 'NSW', type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'Northern Territory', code: 'NT', type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'Queensland', code: 'QLD', type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'South Australia', code: 'SA', type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'Tasmania', code: 'TAS', type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'Victoria', code: 'VIC', type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'Western Australia', code: 'WA', type: 'State', parent_code: 'AU', aliases: [] },
]

korean_provinces = [
  {name: 'Gyeonggi-do', code: '경기도', type: 'State', parent_code: 'KR', aliases: [] },
]


us_cities = [
  { name: 'Atlanta', code: nil, type: 'City', parent_code: 'GA', aliases: [] },
  { name: 'Austin', code: nil, type: 'City', parent_code: 'TX', aliases: ['Downtown', 'East Austin', 'South Congress', 'Zilker', 'Hyde Park'] },
  { name: 'Baltimore', code: nil, type: 'City', parent_code: 'MD', aliases: [] },
  { name: 'Boston', code: nil, type: 'City', parent_code: 'MA', aliases: ['Back Bay', 'South End', 'Fenway', 'Beacon Hill', 'Seaport', 'Cambridge', 'Somerville', 'Watertown'] },
  { name: 'Charlotte', code: nil, type: 'City', parent_code: 'NC', aliases: [] },
  { name: 'Chicago', code: nil, type: 'City', parent_code: 'IL', aliases: ['Loop', 'River North', 'Lincoln Park', 'Wicker Park', 'South Loop', 'Brookfield', 'Schaumburg'] },
  { name: 'Cincinnati', code: nil, type: 'City', parent_code: 'OH', aliases: [] },
  { name: 'Dallas', code: nil, type: 'City', parent_code: 'TX', aliases: ['Richardson'] },
  { name: 'Denver', code: nil, type: 'City', parent_code: 'CO', aliases: ['LoDo', 'Capitol Hill', 'Cherry Creek', 'Highlands', 'RiNo', 'Aurora'] },
  { name: 'Detroit', code: nil, type: 'City', parent_code: 'MI', aliases: [] },
  { name: 'Durham', code: nil, type: 'City', parent_code: 'NC', aliases: ['Chapel Hill'] },
  { name: 'Emeryville', code: nil, type: 'City', parent_code: 'CA', aliases: [] },
  { name: 'Fort Worth', code: nil, type: 'City', parent_code: 'TX', aliases: ['Arlington', 'ft worth'] },
  { name: 'Houston', code: nil, type: 'City', parent_code: 'TX', aliases: [] },
  { name: 'Indianapolis', code: nil, type: 'City', parent_code: 'IN', aliases: ['Carmel', 'Fortville'] },
  { name: 'Las Vegas', code: nil, type: 'City', parent_code: 'NV', aliases: ['Henderson'] },
  { name: 'Lincoln', code: nil, type: 'City', parent_code: 'NE', aliases: ['Omaha'] },
  { name: 'Los Angeles', code: nil, type: 'City', parent_code: 'CA', aliases: ['Hollywood', 'Santa Monica', 'Beverly Hills', 'Venice', 'Downtown LA', 'Westwood', 'Silver Lake', 'West Hollywood', 'Van Nuys', 'Burbank', 'El Segundo', 'dtla', 'Covina', 'Newport Beach', 'Corona del Mar', 'Riverside', 'Pasadena'] },
  { name: 'Madison', code: nil, type: 'City', parent_code: 'WI', aliases: [] },
  { name: 'Miami', code: nil, type: 'City', parent_code: 'FL', aliases: ['Brickell', 'Wynwood', 'Little Havana', 'Coconut Grove', 'South Beach', 'Coral Gables'] },
  { name: 'Memphis', code: nil, type: 'City', parent_code: 'TN', aliases: [] },
  { name: 'Minneapolis', code: nil, type: 'City', parent_code: 'MN', aliases: [] },
  { name: 'Nashville', code: nil, type: 'City', parent_code: 'TN', aliases: [] },
  { name: 'New Orleans', code: nil, type: 'City', parent_code: 'LA', aliases: ['Metairie'] },
  { name: 'New York', code: nil, type: 'City', parent_code: 'NY', aliases: ['New York City', 'Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island', 'Harlem', 'SoHo', 'Tribeca', 'Chelsea', 'Long Island City', 'Nutely', 'Union', 'Newark', 'Hoboken'] },
  { name: 'Oakland', code: nil, type: 'City', parent_code: 'CA', aliases: ['Piedmont', 'Alameda'] },
  { name: 'Orlando', code: nil, type: 'City', parent_code: 'FL', aliases: [] },
  { name: 'Palo Alto', code: nil, type: 'City', parent_code: 'CA', aliases: ['Stanford'] },
  { name: 'Philadelphia', code: nil, type: 'City', parent_code: 'PA', aliases: ['Radnor', 'King of Prussia', 'Lower Gwynedd', 'Doylestown'] },
  { name: 'Pittsburgh', code: nil, type: 'City', parent_code: 'PA', aliases: [] },
  { name: 'Portland', code: nil, type: 'City', parent_code: 'OR', aliases: [] },
  { name: 'Raleigh', code: nil, type: 'City', parent_code: 'NC', aliases: ['Wake Forest'] },
  { name: 'Sacramento', code: nil, type: 'City', parent_code: 'CA', aliases: [] },
  { name: 'Salt Lake City', code: nil, type: 'City', parent_code: 'UT', aliases: [] },
  { name: 'San Diego', code: nil, type: 'City', parent_code: 'CA', aliases: ['Sunnyvale'] },
  { name: 'San Francisco', code: nil, type: 'City', parent_code: 'CA', aliases: ['SOMA', 'Mission District', 'Financial District', 'Nob Hill', 'Castro', 'Pacific Heights', 'South San Francisco', 'Hayward', 'Emeryville', 'Fremont', 'San Mateo', 'Burlingame', 'San Carlos', 'Berkeley', 'Novato'] },
  { name: 'San Jose', code: nil, type: 'City', parent_code: 'CA', aliases: [] },
  { name: 'Santa Clara', code: nil, type: 'City', parent_code: 'CA', aliases: ['Santa Cruz', 'Santa Ana'] },
  { name: 'Savannah', code: nil, type: 'City', parent_code: 'GA', aliases: [] },
  { name: 'Scottsdale', code: nil, type: 'City', parent_code: 'AZ', aliases: ['Tempe'] },
  { name: 'Seattle', code: nil, type: 'City', parent_code: 'WA', aliases: ['Capitol Hill', 'Belltown', 'Ballard', 'Fremont', 'Queen Anne', 'South Lake Union', 'Bothell', 'Kirkland', 'Bellevue'] },
  { name: 'Tampa', code: nil, type: 'City', parent_code: 'FL', aliases: [] },
  { name: 'Washington', code: nil, type: 'City', parent_code: 'DC', aliases: ['Georgetown', 'Dupont Circle', 'Capitol Hill', 'Foggy Bottom', 'Adams Morgan', 'Columbia Heights', 'Washington DC', 'Washington D.C.', 'Bethesda', 'Tysons', 'Rockville', 'Fairfax'] },
]

international_cities =[
  # International Cities
  { name: 'Amsterdam', code: nil, type: 'City', parent_code: 'NL', aliases: [] },
  { name: 'Barcelona', code: nil, type: 'City', parent_code: 'ES', aliases: [] },
  { name: 'Beijing', code: nil, type: 'City', parent_code: 'CN', aliases: [] },
  { name: 'Bengaluru', code: nil, type: 'City', parent_code: 'IN', aliases: ['Bangalore'] },
  { name: 'Berlin', code: nil, type: 'City', parent_code: 'DE', aliases: [] },
  { name: 'Cambridge', code: nil, type: 'City', parent_code: 'UK', aliases: ['Greater Cambridge'] },
  { name: 'Dublin', code: nil, type: 'City', parent_code: 'IE', aliases: [] },
  { name: 'Dubai', code: nil, type: 'City', parent_code: 'AE', aliases: [] },
  { name: 'Frankfurt', code: nil, type: 'City', parent_code: 'DE', aliases: [] },
  { name: 'Hong Kong', code: nil, type: 'City', parent_code: 'HK', aliases: [] },
  { name: 'Guangzhou', code: nil, type: 'City', parent_code: 'CN', aliases: [] },
  { name: 'Johannesburg', code: nil, type: 'City', parent_code: 'ZA', aliases: [] },
  { name: 'Lisbon', code: nil, type: 'City', parent_code: 'PT', aliases: [] },
  { name: 'London', code: nil, type: 'City', parent_code: 'UK', aliases: ['greater london'] },
  { name: 'Manila', code: nil, type: 'City', parent_code: 'PH', aliases: [] },
  { name: 'Melbourne', code: nil, type: 'City', parent_code: 'VIC', aliases: [] },
  { name: 'Mexico City', code: nil, type: 'City', parent_code: 'MX', aliases: [] },
  { name: 'Milan', code: nil, type: 'City', parent_code: 'IT', aliases: [] },
  { name: 'Munich', code: nil, type: 'City', parent_code: 'DE', aliases: [] },
  { name: 'Mumbai', code: nil, type: 'City', parent_code: 'IN', aliases: [] },
  { name: 'Ottawa', code: nil, type: 'City', parent_code: 'ON', aliases: [] },
  { name: 'Paris', code: nil, type: 'City', parent_code: 'FR', aliases: ['Greater Paris'] },
  { name: 'Pune', code: nil, type: 'City', parent_code: 'IN', aliases: [] },
  { name: 'Rio de Janeiro', code: nil, type: 'City', parent_code: 'BR', aliases: [] },
  { name: 'São Paulo', code: nil, type: 'City', parent_code: 'BR', aliases: [] },
  { name: 'Seoul', code: nil, type: 'City', parent_code: 'KR', aliases: ['Gangnam', 'gangnam-gu'] },
  { name: 'Shanghai', code: nil, type: 'City', parent_code: 'CN', aliases: [] },
  { name: 'Singapore', code: nil, type: 'City', parent_code: 'SG', aliases: [] },
  { name: 'South Morang', code: nil, type: 'City', parent_code: 'VIC', aliases: [] },
  { name: 'Stockholm', code: nil, type: 'City', parent_code: 'SE', aliases: [] },
  { name: 'Sydney', code: nil, type: 'City', parent_code: 'NSW', aliases: [] },
  { name: 'Tallinn', code: nil, type: 'City', parent_code: 'EE', aliases: [] },
  { name: 'Tel Aviv', code: nil, type: 'City', parent_code: 'IL', aliases: [] },
  { name: 'Tokyo', code: nil, type: 'City', parent_code: 'JP', aliases: [] },
  { name: 'Toronto', code: nil, type: 'City', parent_code: 'ON', aliases: [] },
  { name: 'Vancouver', code: nil, type: 'City', parent_code: 'BC', aliases: [] }
]
seeded_count = 0
existing_count = 0
updated_count = 0

def find_parent_id(parent_code, type)
  Location.find_by(code: parent_code, type: type)&.id
end

[countries, us_states, canadian_provinces, australian_states, korean_provinces].each do |location_array|
  location_array.each do |location_data|
    parent_id = location_data[:parent_code] ? find_parent_id(location_data[:parent_code], location_data[:type] == 'State' ? 'Country' : 'State') : nil
    location = Location.find_or_initialize_by(code: location_data[:code], type: location_data[:type])
    location.name = location_data[:name]
    location.parent_id = parent_id
    location.aliases = location_data[:aliases] || []

    if location.persisted?
      existing_count += 1
    else
      location.save!
      seeded_count += 1
    end
  rescue StandardError => e
    puts "Error processing #{location_data[:name]}: #{e.message}"
  end
end

[us_cities, international_cities].each do |city_array|
  city_array.each do |city_data|
    parent_id = find_parent_id(city_data[:parent_code], 'State')
    if parent_id
      location = Location.find_or_initialize_by(name: city_data[:name], type: city_data[:type])
      location.parent_id = parent_id
      location.aliases = city_data[:aliases] || []

      if location.persisted?
        existing_count += 1
      else
        location.save!
        seeded_count += 1
      end
    else
      puts "Parent state not found for city: #{city_data[:name]}"
    end
  rescue StandardError => e
    puts "Error processing #{city_data[:name]}: #{e.message}"
  end
end

puts "Seeded #{seeded_count} new locations. #{existing_count} locations already existed. Total locations: #{Location.count}."
