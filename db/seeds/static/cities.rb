# frozen_string_literal: true

cities = [
  { city_name: 'Atlanta', state_code: 'GA' },
  { city_name: 'Austin', state_code: 'TX',
    aliases: ['Downtown', 'East Austin', 'South Congress', 'Zilker', 'Hyde Park'] },
  { city_name: 'Baltimore', state_code: 'MD' },
  { city_name: 'Boston', state_code: 'MA',
    aliases: ['Back Bay', 'South End', 'Fenway', 'Beacon Hill', 'Seaport', 'Cambridge', 'Somerville',
              'Watertown'] },
  { city_name: 'Charlotte', state_code: 'NC' },
  { city_name: 'Chicago', state_code: 'IL',
    aliases: ['Loop', 'River North', 'Lincoln Park', 'Wicker Park', 'South Loop', 'Brookfield',
              'Schaumburg'] },
  { city_name: 'Cincinnati', state_code: 'OH' },
  { city_name: 'Dallas', state_code: 'TX', aliases: ['Richardson'] },
  { city_name: 'Denver', state_code: 'CO',
    aliases: ['LoDo', 'Capitol Hill', 'Cherry Creek', 'Highlands', 'RiNo', 'Aurora'] },
  { city_name: 'Detroit', state_code: 'MI' },
  { city_name: 'Durham', state_code: 'NC', aliases: ['Chapel Hill'] },
  { city_name: 'Emeryville', state_code: 'CA' },
  { city_name: 'Fort Worth', state_code: 'TX', aliases: ['Arlington', 'ft worth'] },
  { city_name: 'Houston', state_code: 'TX' },
  { city_name: 'Indianapolis', state_code: 'IN', aliases: %w[Carmel Fortville] },
  { city_name: 'Las Vegas', state_code: 'NV', aliases: ['Henderson'] },
  { city_name: 'Lincoln', state_code: 'NE', aliases: ['Omaha'] },
  { city_name: 'Los Angeles', state_code: 'CA',
    aliases: ['Hollywood', 'Santa Monica', 'Beverly Hills', 'Venice', 'Downtown LA', 'Westwood',
              'Silver Lake', 'West Hollywood', 'Van Nuys', 'Burbank', 'El Segundo', 'dtla',
              'Covina', 'Newport Beach', 'Corona del Mar', 'Riverside', 'Pasadena'] },
  { city_name: 'Madison', state_code: 'WI' },
  { city_name: 'Miami', state_code: 'FL',
    aliases: ['Brickell', 'Wynwood', 'Little Havana', 'Coconut Grove', 'South Beach',
              'Coral Gables'] },
  { city_name: 'Memphis', state_code: 'TN' },
  { city_name: 'Minneapolis', state_code: 'MN' },
  { city_name: 'Nashville', state_code: 'TN' },
  { city_name: 'New Orleans', state_code: 'LA', aliases: ['Metairie'] },
  { city_name: 'New York', state_code: 'NY',
    aliases: ['New York City', 'Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island', 'Harlem', 'SoHo', 'Tribeca',
              'Chelsea', 'Long Island City', 'Nutely', 'Union', 'Newark', 'Hoboken'] },
  { city_name: 'Oakland', state_code: 'CA', aliases: %w[Piedmont Alameda] },
  { city_name: 'Orlando', state_code: 'FL' },
  { city_name: 'Palo Alto', state_code: 'CA', aliases: ['Stanford'] },
  { city_name: 'Philadelphia', state_code: 'PA',
    aliases: ['Radnor', 'King of Prussia', 'Lower Gwynedd', 'Doylestown'] },
  { city_name: 'Pittsburgh', state_code: 'PA' },
  { city_name: 'Portland', state_code: 'OR' },
  { city_name: 'Raleigh', state_code: 'NC', aliases: ['Wake Forest'] },
  { city_name: 'Sacramento', state_code: 'CA' },
  { city_name: 'Salt Lake City', state_code: 'UT' },
  { city_name: 'San Diego', state_code: 'CA', aliases: ['Sunnyvale'] },
  { city_name: 'San Francisco', state_code: 'CA',
    aliases: ['SOMA', 'Mission District', 'Financial District', 'Nob Hill', 'Castro',
              'Pacific Heights', 'South San Francisco', 'Hayward', 'Emeryville', 'Fremont', 'San Mateo', 'Burlingame', 'San Carlos',
              'Berkeley', 'Novato'] },
  { city_name: 'San Jose', state_code: 'CA' },
  { city_name: 'Santa Clara', state_code: 'CA', aliases: ['Santa Cruz', 'Santa Ana'] },
  { city_name: 'Savannah', state_code: 'GA' },
  { city_name: 'Scottsdale', state_code: 'AZ', aliases: ['Tempe'] },
  { city_name: 'Seattle', state_code: 'WA',
    aliases: ['Capitol Hill', 'Belltown', 'Ballard', 'Fremont', 'Queen Anne', 'South Lake Union', 'Bothell',
              'Kirkland', 'Bellevue'] },
  { city_name: 'Tampa', state_code: 'FL' },
  { city_name: 'Washington', state_code: 'DC',
    aliases: ['Georgetown', 'Dupont Circle', 'Capitol Hill', 'Foggy Bottom', 'Adams Morgan',
              'Columbia Heights', 'Washington DC', 'Washington D.C.', 'Bethesda', 'Tysons', 'Rockville', 'Fairfax'] },

  { city_name: 'Amsterdam' }, # Netherlands
  { city_name: 'Barcelona' }, # Spain
  { city_name: 'Beijing' }, # China
  { city_name: 'Bengaluru', aliases: ['Bangalore'] }, # India
  { city_name: 'Berlin' }, # Germany
  { city_name: 'Cambridge', aliases: ['Greater Cambridge'] }, # UK
  { city_name: 'Dublin' }, # Ireland
  { city_name: 'Dubai' }, # United Arab Emirates
  { city_name: 'Frankfurt' }, # Germany
  { city_name: 'Hong Kong' }, # China
  { city_name: 'Guangzhou' }, # China
  { city_name: 'Johannesburg' }, # South Africa
  { city_name: 'Lisbon' }, # Portugal
  { city_name: 'London', aliases: ['greater london'] }, # United Kingdom
  { city_name: 'Manila' }, # Philippines
  { city_name: 'Melbourne' }, # Australia
  { city_name: 'Mexico City' }, # Mexico
  { city_name: 'Milan' }, # Italy
  { city_name: 'Munich' },  # Germany
  { city_name: 'Mumbai' },  # India
  { city_name: 'Ottawa' }, # Canada
  { city_name: 'Paris', aliases: ['Greater Paris'] }, # France
  { city_name: 'Pune' }, # India
  { city_name: 'Rio de Janeiro' }, # Brazil
  { city_name: 'São Paulo' }, # Brazil
  { city_name: 'Seoul' }, # South Korea
  { city_name: 'Shanghai' }, # China
  { city_name: 'Singapore' }, # Singapore
  { city_name: 'South Morang' }, # Australia
  { city_name: 'Stockholm' }, # Sweden
  { city_name: 'Sydney' }, # Australia
  { city_name: 'Tallinn' }, # Estonia
  { city_name: 'Tel Aviv' }, # Israel
  { city_name: 'Tokyo' }, # Japan
  { city_name: 'Toronto' }, # Canada
  { city_name: 'Vancouver' } # Canada
]

seeded_count = 0
existing_count = 0
updated_count = 0

cities.each do |city|
  city_record = City.find_or_initialize_by(city_name: city[:city_name])

  if city_record.persisted?
    existing_count += 1

    updated = false
    if city[:aliases] && city_record.aliases != city[:aliases]
      city_record.aliases = city[:aliases]
      updated = true
    end

    if city[:state_code] && city_record.state_code != city[:state_code]
      city_record.state_code = city[:state_code]
      updated = true
    end

    if updated
      city_record.save!
      updated_count += 1
      puts "Updated city #{city[:city_name]} with new data."
    else
      puts "City #{city[:city_name]} is already up-to-date."
    end
  else
    city_record.aliases = city[:aliases] if city[:aliases]
    city_record.state_code = city[:state_code] if city[:state_code]
    city_record.save!
    seeded_count += 1
    puts "Seeded new city: #{city[:city_name]} with state_code: #{city[:state_code]} and aliases: #{city[:aliases]}"
  end
end

total_cities = City.count
puts "*********** Seeded #{seeded_count} new cities. #{existing_count} cities already existed. #{updated_count} cities updated. Total cities in the table: #{total_cities}."
