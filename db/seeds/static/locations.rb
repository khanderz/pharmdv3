# frozen_string_literal: true

countries = [
  { name: 'Australia', code: 'AU', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Bangladesh', code: 'BD', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Brazil', code: 'BR', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Canada', code: 'CA', location_type: 'Country', parent_code: nil,
    aliases: ['Great White North'] },
  { name: 'China', code: 'CN', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Egypt', code: 'EG', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Estonia', code: 'EE', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'France', code: 'FR', location_type: 'Country', parent_code: nil,
    aliases: ['République Française'] },
  { name: 'Germany', code: 'DE', location_type: 'Country', parent_code: nil,
    aliases: ['Deutschland'] },
  { name: 'Hong Kong', code: 'HK', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'India', code: 'IN', location_type: 'Country', parent_code: nil, aliases: ['Bharat'] },
  { name: 'Indonesia', code: 'ID', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Ireland', code: 'IE', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Israel', code: 'IL', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Italy', code: 'IT', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Japan', code: 'JP', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Malaysia', code: 'MY', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Mexico', code: 'MX', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Netherlands', code: 'NL', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Nigeria', code: 'NG', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Philippines', code: 'PH', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Portugal', code: 'PT', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Russia', code: 'RU', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Saudi Arabia', code: 'SA', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Singapore', code: 'SG', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'South Africa', code: 'ZA', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'South Korea', code: 'KR', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Spain', code: 'ES', location_type: 'Country', parent_code: nil, aliases: ['España'] },
  { name: 'Sweden', code: 'SE', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Switzerland', code: 'CH', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Thailand', code: 'TH', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'Turkey', code: 'TR', location_type: 'Country', parent_code: nil, aliases: [] },
  { name: 'United Arab Emirates', code: 'AE', location_type: 'Country', parent_code: nil,
    aliases: [] },
  { name: 'United Kingdom', code: 'GB', location_type: 'Country', parent_code: nil,
    aliases: ['UK', 'Britain', 'Great Britain'] },
  { name: 'United States', code: 'US', location_type: 'Country', parent_code: nil,
    aliases: ['USA', 'America', 'United States of America'] },
  { name: 'Vietnam', code: 'VN', location_type: 'Country', parent_code: nil, aliases: [] }
]

us_states = [
  { name: 'Alabama', code: 'AL', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Alaska', code: 'AK', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Arizona', code: 'AZ', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Arkansas', code: 'AR', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'California', code: 'CA', location_type: 'State', parent_code: 'US',
    aliases: ['Calif.', 'Golden State'] },
  { name: 'Colorado', code: 'CO', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Connecticut', code: 'CT', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Delaware', code: 'DE', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'District of Columbia', code: 'DC', location_type: 'State', parent_code: 'US',
    aliases: ['Washington DC', 'Washington D.C.'] },
  { name: 'Florida', code: 'FL', location_type: 'State', parent_code: 'US', aliases: ['Fla.'] },
  { name: 'Georgia', code: 'GA', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Hawaii', code: 'HI', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Idaho', code: 'ID', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Illinois', code: 'IL', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Indiana', code: 'IN', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Iowa', code: 'IA', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Kansas', code: 'KS', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Kentucky', code: 'KY', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Louisiana', code: 'LA', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Maine', code: 'ME', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Maryland', code: 'MD', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Massachusetts', code: 'MA', location_type: 'State', parent_code: 'US',
    aliases: ['Mass.'] },
  { name: 'Michigan', code: 'MI', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Minnesota', code: 'MN', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Mississippi', code: 'MS', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Missouri', code: 'MO', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Montana', code: 'MT', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Nebraska', code: 'NE', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Nevada', code: 'NV', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'New Hampshire', code: 'NH', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'New Jersey', code: 'NJ', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'New Mexico', code: 'NM', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'New York', code: 'NY', location_type: 'State', parent_code: 'US',
    aliases: ['NY State'] },
  { name: 'North Carolina', code: 'NC', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'North Dakota', code: 'ND', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Ohio', code: 'OH', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Oklahoma', code: 'OK', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Oregon', code: 'OR', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Pennsylvania', code: 'PA', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Rhode Island', code: 'RI', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'South Carolina', code: 'SC', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'South Dakota', code: 'SD', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Tennessee', code: 'TN', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Texas', code: 'TX', location_type: 'State', parent_code: 'US', aliases: ['Tex.'] },
  { name: 'Utah', code: 'UT', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Vermont', code: 'VT', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Virginia', code: 'VA', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Washington', code: 'WA', location_type: 'State', parent_code: 'US', aliases: ['Wash.'] },
  { name: 'West Virginia', code: 'WV', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Wisconsin', code: 'WI', location_type: 'State', parent_code: 'US', aliases: [] },
  { name: 'Wyoming', code: 'WY', location_type: 'State', parent_code: 'US', aliases: [] },
]

canadian_provinces = [
  { name: 'Alberta', code: 'AB', location_type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'British Columbia', code: 'BC', location_type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Manitoba', code: 'MB', location_type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'New Brunswick', code: 'NB', location_type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Newfoundland and Labrador', code: 'NL', location_type: 'State', parent_code: 'CA',
    aliases: [] },
  { name: 'Nova Scotia', code: 'NS', location_type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Ontario', code: 'ON', location_type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Prince Edward Island', code: 'PE', location_type: 'State', parent_code: 'CA',
    aliases: [] },
  { name: 'Quebec', code: 'QC', location_type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Saskatchewan', code: 'SK', location_type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Northwest Territories', code: 'NT', location_type: 'State', parent_code: 'CA',
    aliases: [] },
  { name: 'Nunavut', code: 'NU', location_type: 'State', parent_code: 'CA', aliases: [] },
  { name: 'Yukon', code: 'YT', location_type: 'State', parent_code: 'CA', aliases: [] },
]

australian_states = [
  { name: 'Australian Capital Territory', code: 'ACT', location_type: 'State', parent_code: 'AU',
    aliases: [] },
  { name: 'New South Wales', code: 'NSW', location_type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'Northern Territory', code: 'NT', location_type: 'State', parent_code: 'AU',
    aliases: [] },
  { name: 'Queensland', code: 'QLD', location_type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'South Australia', code: 'SA', location_type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'Tasmania', code: 'TAS', location_type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'Victoria', code: 'VIC', location_type: 'State', parent_code: 'AU', aliases: [] },
  { name: 'Western Australia', code: 'WA', location_type: 'State', parent_code: 'AU', aliases: [] },
]

korean_provinces = [
  { name: 'Gyeonggi-do', code: '경기도', location_type: 'State', parent_code: 'KR', aliases: [] },
]

us_cities = [
  { name: 'Atlanta', code: nil, location_type: 'City', parent_code: 'GA', aliases: [] },
  { name: 'Austin', code: nil, location_type: 'City', parent_code: 'TX',
    aliases: ['Downtown', 'East Austin', 'South Congress', 'Zilker', 'Hyde Park'] },
  { name: 'Baltimore', code: nil, location_type: 'City', parent_code: 'MD', aliases: [] },
  { name: 'Boston', code: nil, location_type: 'City', parent_code: 'MA',
    aliases: ['Back Bay', 'South End', 'Fenway', 'Beacon Hill', 'Seaport', 'Cambridge', 'Somerville', 'Watertown'] },
  { name: 'Charlotte', code: nil, location_type: 'City', parent_code: 'NC', aliases: [] },
  { name: 'Chicago', code: nil, location_type: 'City', parent_code: 'IL',
    aliases: ['Loop', 'River North', 'Lincoln Park', 'Wicker Park', 'South Loop', 'Brookfield', 'Schaumburg'] },
  { name: 'Cincinnati', code: nil, location_type: 'City', parent_code: 'OH', aliases: [] },
  { name: 'Dallas', code: nil, location_type: 'City', parent_code: 'TX', aliases: ['Richardson'] },
  { name: 'Denver', code: nil, location_type: 'City', parent_code: 'CO',
    aliases: ['LoDo', 'Capitol Hill', 'Cherry Creek', 'Highlands', 'RiNo', 'Aurora'] },
  { name: 'Detroit', code: nil, location_type: 'City', parent_code: 'MI', aliases: [] },
  { name: 'Durham', code: nil, location_type: 'City', parent_code: 'NC', aliases: ['Chapel Hill'] },
  { name: 'Emeryville', code: nil, location_type: 'City', parent_code: 'CA', aliases: [] },
  { name: 'Fort Worth', code: nil, location_type: 'City', parent_code: 'TX',
    aliases: ['Arlington', 'ft worth'] },
  { name: 'Houston', code: nil, location_type: 'City', parent_code: 'TX', aliases: [] },
  { name: 'Indianapolis', code: nil, location_type: 'City', parent_code: 'IN',
    aliases: %w[Carmel Fortville] },
  { name: 'Las Vegas', code: nil, location_type: 'City', parent_code: 'NV',
    aliases: ['Henderson'] },
  { name: 'Lincoln', code: nil, location_type: 'City', parent_code: 'NE', aliases: ['Omaha'] },
  { name: 'Los Angeles', code: nil, location_type: 'City', parent_code: 'CA',
    aliases: ['Hollywood', 'Santa Monica', 'Beverly Hills', 'Venice', 'Downtown LA', 'Westwood', 'Silver Lake', 'West Hollywood', 'Van Nuys', 'Burbank', 'El Segundo', 'dtla', 'Covina', 'Newport Beach', 'Corona del Mar', 'Riverside', 'Pasadena'] },
  { name: 'Madison', code: nil, location_type: 'City', parent_code: 'WI', aliases: [] },
  { name: 'Miami', code: nil, location_type: 'City', parent_code: 'FL',
    aliases: ['Brickell', 'Wynwood', 'Little Havana', 'Coconut Grove', 'South Beach', 'Coral Gables'] },
  { name: 'Memphis', code: nil, location_type: 'City', parent_code: 'TN', aliases: [] },
  { name: 'Minneapolis', code: nil, location_type: 'City', parent_code: 'MN', aliases: [] },
  { name: 'Nashville', code: nil, location_type: 'City', parent_code: 'TN', aliases: [] },
  { name: 'New Orleans', code: nil, location_type: 'City', parent_code: 'LA',
    aliases: ['Metairie'] },
  { name: 'New York', code: nil, location_type: 'City', parent_code: 'NY',
    aliases: ['New York City', 'Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island', 'Harlem', 'SoHo', 'Tribeca', 'Chelsea', 'Long Island City', 'Nutely', 'Union', 'Newark', 'Hoboken'] },
  { name: 'Oakland', code: nil, location_type: 'City', parent_code: 'CA',
    aliases: %w[Piedmont Alameda] },
  { name: 'Orlando', code: nil, location_type: 'City', parent_code: 'FL', aliases: [] },
  { name: 'Palo Alto', code: nil, location_type: 'City', parent_code: 'CA', aliases: ['Stanford'] },
  { name: 'Philadelphia', code: nil, location_type: 'City', parent_code: 'PA',
    aliases: ['Radnor', 'King of Prussia', 'Lower Gwynedd', 'Doylestown'] },
  { name: 'Pittsburgh', code: nil, location_type: 'City', parent_code: 'PA', aliases: [] },
  { name: 'Portland', code: nil, location_type: 'City', parent_code: 'OR', aliases: [] },
  { name: 'Raleigh', code: nil, location_type: 'City', parent_code: 'NC',
    aliases: ['Wake Forest'] },
  { name: 'Sacramento', code: nil, location_type: 'City', parent_code: 'CA', aliases: [] },
  { name: 'Salt Lake City', code: nil, location_type: 'City', parent_code: 'UT', aliases: [] },
  { name: 'San Diego', code: nil, location_type: 'City', parent_code: 'CA',
    aliases: ['Sunnyvale'] },
  { name: 'San Francisco', code: nil, location_type: 'City', parent_code: 'CA',
    aliases: ['SOMA', 'Mission District', 'Financial District', 'Nob Hill', 'Castro', 'Pacific Heights', 'South San Francisco', 'Hayward', 'Emeryville', 'Fremont', 'San Mateo', 'Burlingame', 'San Carlos', 'Berkeley', 'Novato'] },
  { name: 'San Jose', code: nil, location_type: 'City', parent_code: 'CA', aliases: [] },
  { name: 'Santa Clara', code: nil, location_type: 'City', parent_code: 'CA',
    aliases: ['Santa Cruz', 'Santa Ana'] },
  { name: 'Savannah', code: nil, location_type: 'City', parent_code: 'GA', aliases: [] },
  { name: 'Scottsdale', code: nil, location_type: 'City', parent_code: 'AZ', aliases: ['Tempe'] },
  { name: 'Seattle', code: nil, location_type: 'City', parent_code: 'WA',
    aliases: ['Capitol Hill', 'Belltown', 'Ballard', 'Fremont', 'Queen Anne', 'South Lake Union', 'Bothell', 'Kirkland', 'Bellevue'] },
  { name: 'Tampa', code: nil, location_type: 'City', parent_code: 'FL', aliases: [] },
  { name: 'Washington', code: nil, location_type: 'City', parent_code: 'DC',
    aliases: ['Georgetown', 'Dupont Circle', 'Capitol Hill', 'Foggy Bottom', 'Adams Morgan', 'Columbia Heights', 'Washington DC', 'Washington D.C.', 'Bethesda', 'Tysons', 'Rockville', 'Fairfax'] },
]

international_cities = [
  { name: 'Amsterdam', code: nil, location_type: 'City', parent_code: 'NL', aliases: [] },
  { name: 'Barcelona', code: nil, location_type: 'City', parent_code: 'ES', aliases: [] },
  { name: 'Beijing', code: nil, location_type: 'City', parent_code: 'CN', aliases: [] },
  { name: 'Bengaluru', code: nil, location_type: 'City', parent_code: 'IN',
    aliases: ['Bangalore'] },
  { name: 'Berlin', code: nil, location_type: 'City', parent_code: 'DE', aliases: [] },
  { name: 'Cambridge', code: nil, location_type: 'City', parent_code: 'UK',
    aliases: ['Greater Cambridge'] },
  { name: 'Dublin', code: nil, location_type: 'City', parent_code: 'IE', aliases: [] },
  { name: 'Dubai', code: nil, location_type: 'City', parent_code: 'AE', aliases: [] },
  { name: 'Frankfurt', code: nil, location_type: 'City', parent_code: 'DE', aliases: [] },
  { name: 'Hong Kong', code: nil, location_type: 'City', parent_code: 'HK', aliases: [] },
  { name: 'Guangzhou', code: nil, location_type: 'City', parent_code: 'CN', aliases: [] },
  { name: 'Johannesburg', code: nil, location_type: 'City', parent_code: 'ZA', aliases: [] },
  { name: 'Lisbon', code: nil, location_type: 'City', parent_code: 'PT', aliases: [] },
  { name: 'London', code: nil, location_type: 'City', parent_code: 'UK',
    aliases: ['greater london'] },
  { name: 'Manila', code: nil, location_type: 'City', parent_code: 'PH', aliases: [] },
  { name: 'Melbourne', code: nil, location_type: 'City', parent_code: 'VIC', aliases: [] },
  { name: 'Mexico City', code: nil, location_type: 'City', parent_code: 'MX', aliases: [] },
  { name: 'Milan', code: nil, location_type: 'City', parent_code: 'IT', aliases: [] },
  { name: 'Munich', code: nil, location_type: 'City', parent_code: 'DE', aliases: [] },
  { name: 'Mumbai', code: nil, location_type: 'City', parent_code: 'IN', aliases: [] },
  { name: 'Nice', code: nil, location_type: 'City', parent_code: 'FR', aliases: [] }, 
  { name: 'Ottawa', code: nil, location_type: 'City', parent_code: 'ON', aliases: [] },
  { name: 'Paris', code: nil, location_type: 'City', parent_code: 'FR',
    aliases: ['Greater Paris'] },
  { name: 'Pune', code: nil, location_type: 'City', parent_code: 'IN', aliases: [] },
  { name: 'Rio de Janeiro', code: nil, location_type: 'City', parent_code: 'BR', aliases: [] },
  { name: 'São Paulo', code: nil, location_type: 'City', parent_code: 'BR', aliases: [] },
  { name: 'Seoul', code: nil, location_type: 'City', parent_code: 'KR',
    aliases: %w[Gangnam gangnam-gu] },
  { name: 'Shanghai', code: nil, location_type: 'City', parent_code: 'CN', aliases: [] },
  { name: 'Singapore', code: nil, location_type: 'City', parent_code: 'SG', aliases: [] },
  { name: 'South Morang', code: nil, location_type: 'City', parent_code: 'VIC', aliases: [] },
  { name: 'Stockholm', code: nil, location_type: 'City', parent_code: 'SE', aliases: [] },
  { name: 'Sydney', code: nil, location_type: 'City', parent_code: 'NSW', aliases: [] },
  { name: 'Tallinn', code: nil, location_type: 'City', parent_code: 'EE', aliases: [] },
  { name: 'Tel Aviv', code: nil, location_type: 'City', parent_code: 'IL', aliases: [] },
  { name: 'Tokyo', code: nil, location_type: 'City', parent_code: 'JP', aliases: [] },
  { name: 'Toronto', code: nil, location_type: 'City', parent_code: 'ON', aliases: [] },
  { name: 'Vancouver', code: nil, location_type: 'City', parent_code: 'BC', aliases: [] }
]
seeded_count = 0
existing_count = 0
updated_count = 0

def find_parent_id(parent_code, location_type)
  location = Location.where(location_type: location_type)
                     .where('LOWER(code) = ? OR ? = ANY(aliases)', parent_code.downcase, parent_code)
                     .first
  location&.id
end

[countries, us_states, canadian_provinces, australian_states,
 korean_provinces].each do |location_array|
  location_array.each do |location_data|
    parent_id = if location_data[:parent_code]
                  find_parent_id(location_data[:parent_code],
                                 location_data[:location_type] == 'State' ? 'Country' : 'State')
                end
    location = Location.find_or_initialize_by(code: location_data[:code],
                                              location_type: location_data[:location_type])
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

    parent_id = find_parent_id(city_data[:parent_code], 'Country') if parent_id.nil?

    if parent_id
      location = Location.find_or_initialize_by(name: city_data[:name],
                                                location_type: city_data[:location_type])
      location.parent_id = parent_id
      location.aliases = city_data[:aliases] || []

      if location.persisted?
        existing_count += 1
      else
        location.save!
        seeded_count += 1
      end
    else
      puts "Parent not found for city: #{city_data[:name]} with parent_code #{city_data[:parent_code]}"
    end
  rescue StandardError => e
    puts "Error processing #{city_data[:name]}: #{e.message}"
  end
end

puts "Seeded #{seeded_count} new locations. #{existing_count} locations already existed. Total locations: #{Location.count}."
