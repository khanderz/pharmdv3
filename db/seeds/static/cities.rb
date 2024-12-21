# frozen_string_literal: true

cities = [
  { city_name: 'Atlanta' },
  { city_name: 'Austin',
    aliases: ['Downtown', 'East Austin', 'South Congress', 'Zilker', 'Hyde Park'] },
  { city_name: 'Baltimore' },
  { city_name: 'Boston', aliases: ['Back Bay', 'South End', 'Fenway', 'Beacon Hill', 'Seaport', 'Cambridge', 'Somerville', 'Watertown'] },
  { city_name: 'Charlotte' },
  { city_name: 'Chicago',
  aliases: ['Loop', 'River North', 'Lincoln Park', 'Wicker Park', 'South Loop', 'Brookfield', 'Schaumburg'] },
  { city_name: 'Cincinnati' },
  { city_name: 'Dallas', aliases: ['Richardson'] },
  { city_name: 'Denver', aliases: ['LoDo', 'Capitol Hill', 'Cherry Creek', 'Highlands', 'RiNo', 'Aurora'] },
  { city_name: 'Detroit' },
  { city_name: 'Durham', aliases: ['Chapel Hill'] },
  { city_name: 'Emeryville' },
  { city_name: 'Fort Worth', aliases: ['Arlington', 'ft worth'] },
  { city_name: 'Houston' },
  { city_name: 'Indianapolis', aliases: ['Carmel', 'Fortville'] },
  { city_name: 'Las Vegas', aliases: ['Henderson'] },
  { city_name: 'Lincoln', aliases: ['Omaha'] },
  { city_name: 'Los Angeles',
    aliases: ['Hollywood', 'Santa Monica', 'Beverly Hills', 'Venice', 'Downtown LA', 'Westwood',
              'Silver Lake', 'West Hollywood', 'Van Nuys', 'Burbank', 'El Segundo', 'dtla',
              'Covina', 'Newport Beach', 'Corona del Mar', 'Riverside'] },
  { city_name: 'Madison' },
  { city_name: 'Miami',
    aliases: ['Brickell', 'Wynwood', 'Little Havana', 'Coconut Grove', 'South Beach', 'Coral Gables'] },
  { city_name: 'Memphis' },
  { city_name: 'Minneapolis' },
  { city_name: 'Nashville' },
  { city_name: 'New Orleans', aliases: ['Metairie'] },
  { city_name: 'New York',
    aliases: ['New York City', 'Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island', 'Harlem', 'SoHo', 'Tribeca',
              'Chelsea', 'Long Island City', 'Nutely', 'Union', 'Newark', 'Hoboken'] },
  { city_name: 'Oakland', aliases: ['Piedmont', 'Alameda'] },
  { city_name: 'Orlando' },
  { city_name: 'Palo Alto', aliases: ['Stanford'] },
  { city_name: 'Philadelphia', aliases: ['Radnor', 'King of Prussia', 'Lower Gwynedd', 'Doylestown'] },
  { city_name: 'Pittsburgh' },
  { city_name: 'Portland' },
  { city_name: 'Raleigh', aliases: ['Wake Forest'] },
  { city_name: 'Sacramento' },
  { city_name: 'Salt Lake City' },
  { city_name: 'San Diego', aliases: ['Sunnyvale'] },
  { city_name: 'San Francisco',
    aliases: ['SOMA', 'Mission District', 'Financial District', 'Nob Hill', 'Castro',
    'Pacific Heights', 'South San Francisco', 'Hayward', 'Emeryville', 'Fremont', 'San Mateo', 'Burlingame' ,'San Carlos',
    'Berkeley', 'Novato'] },
  { city_name: 'San Jose' },
  { city_name: 'Santa Clara', aliases: ['Santa Cruz', 'Santa Ana'] },
  { city_name: 'Savannah' },
  { city_name: 'Scottsdale', aliases: ['Tempe'] },
  { city_name: 'Seattle',
    aliases: ['Capitol Hill', 'Belltown', 'Ballard', 'Fremont', 'Queen Anne', 'South Lake Union', 'Bothell',
    'Kirkland', 'Bellevue'] },
  { city_name: 'Tampa' },
  { city_name: 'Washington',
    aliases: ['Georgetown', 'Dupont Circle', 'Capitol Hill', 'Foggy Bottom', 'Adams Morgan',
              'Columbia Heights', 'Washington DC', 'Washington D.C.', 'Bethesda', 'Tysons', 'Rockville', 'Fairfax'] },

  { city_name: 'Amsterdam' }, # Netherlands
  { city_name: 'Barcelona' }, # Spain
  { city_name: 'Beijing' }, # China
  { city_name: 'Bengaluru', aliases: ['Bangalore'] }, # India
  { city_name: 'Berlin' },  # Germany
  { city_name: 'Cambridge', aliases: ['Greater Cambridge'] }, # UK
  { city_name: 'Dublin' },  # Ireland
  { city_name: 'Dubai' }, # United Arab Emirates
  { city_name: 'Frankfurt' },  # Germany
  { city_name: 'Hong Kong' }, # China
  { city_name: 'Guangzhou' }, # China
  { city_name: 'Johannesburg' }, # South Africa
  { city_name: 'Lisbon' }, # Portugal
  { city_name: 'London', aliases: ['greater london'] }, # United Kingdom
  { city_name: 'Melbourne' }, # Australia
  { city_name: 'Mexico City' }, # Mexico
  { city_name: 'Munich' },  # Germany
  { city_name: 'Mumbai' },  # India
  { city_name: 'Ottawa' }, # Canada
  { city_name: 'Paris', aliases: ['Greater Paris'] }, # France
  { city_name: 'Pune' }, # India
  { city_name: 'Rio de Janeiro' }, # Brazil
  { city_name: 'São Paulo' }, # Brazil
  { city_name: 'Seoul' }, # South Korea
  { city_name: 'Shanghai' }, # China
  { city_name: 'Singapore' },  # Singapore
  { city_name: 'South Morang' }, # Australia
  { city_name: 'Stockholm' },  # Sweden
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

    if city[:aliases] && city_record.aliases != city[:aliases]
      city_record.aliases = city[:aliases]
      city_record.save!
      updated_count += 1
      puts "Updated aliases for city #{city[:city_name]}."
    else
      puts "City #{city[:city_name]} is already up-to-date."
    end
  else
    city_record.aliases = city[:aliases] if city[:aliases]
    city_record.save!
    seeded_count += 1
    puts "Seeded new city: #{city[:city_name]} with aliases: #{city[:aliases]}"
  end
end

total_cities = City.count
puts "*********** Seeded #{seeded_count} new cities. #{existing_count} cities already existed. #{updated_count} cities updated. Total cities in the table: #{total_cities}."
