# frozen_string_literal: true

cities = [
  { city_name: 'Atlanta' },
  { city_name: 'Austin', aliases: ['Downtown', 'East Austin', 'South Congress', 'Zilker', 'Hyde Park'] },
  { city_name: 'Boston', aliases: ['Back Bay', 'South End', 'Fenway', 'Beacon Hill', 'Seaport'] },
  { city_name: 'Charlotte' },
  { city_name: 'Chicago', aliases: ['Loop', 'River North', 'Lincoln Park', 'Wicker Park', 'South Loop'] },
  { city_name: 'Dallas' },
  { city_name: 'Denver', aliases: ['LoDo', 'Capitol Hill', 'Cherry Creek', 'Highlands', 'RiNo'] },
  { city_name: 'Detroit' },
  { city_name: 'Houston' },
  { city_name: 'Las Vegas' },
  { city_name: 'Los Angeles',
    aliases: ['Hollywood', 'Santa Monica', 'Beverly Hills', 'Venice', 'Downtown LA', 'Westwood', 'Silver Lake'] },
  { city_name: 'Miami', aliases: ['Brickell', 'Wynwood', 'Little Havana', 'Coconut Grove', 'South Beach'] },
  { city_name: 'Minneapolis' },
  { city_name: 'Nashville' },
  { city_name: 'New York',
    aliases: ['New York City', 'Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island', 'Harlem', 'SoHo', 'Tribeca',
              'Chelsea'] },
  { city_name: 'Palo Alto' },
  { city_name: 'Philadelphia' },
  { city_name: 'Pittsburgh' },
  { city_name: 'Portland' },
  { city_name: 'Raleigh' },
  { city_name: 'Salt Lake City' },
  { city_name: 'San Diego' },
  { city_name: 'San Francisco',
    aliases: ['SOMA', 'Mission District', 'Financial District', 'Nob Hill', 'Castro', 'Pacific Heights'] },
  { city_name: 'San Jose' },
  { city_name: 'Seattle',
    aliases: ['Capitol Hill', 'Belltown', 'Ballard', 'Fremont', 'Queen Anne', 'South Lake Union'] },
  { city_name: 'Washington',
    aliases: ['Georgetown', 'Dupont Circle', 'Capitol Hill', 'Foggy Bottom', 'Adams Morgan', 'Columbia Heights'] },

  { city_name: 'Amsterdam' }, # Netherlands
  { city_name: 'Beijing' }, # China
  { city_name: 'Bengaluru' }, # India
  { city_name: 'Berlin' },  # Germany
  { city_name: 'Dublin' },  # Ireland
  { city_name: 'Johannesburg' }, # South Africa
  { city_name: 'Lisbon' },  # Portugal
  { city_name: 'London' },  # United Kingdom
  { city_name: 'Melbourne' }, # Australia
  { city_name: 'Mexico City' }, # Mexico
  { city_name: 'Munich' },  # Germany
  { city_name: 'Mumbai' },  # India
  { city_name: 'Paris' }, # France
  { city_name: 'São Paulo' }, # Brazil
  { city_name: 'Seoul' }, # South Korea
  { city_name: 'Shanghai' }, # China
  { city_name: 'Singapore' },  # Singapore
  { city_name: 'Stockholm' },  # Sweden
  { city_name: 'Sydney' }, # Australia
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
    # Check if `aliases` need updating
    if city[:aliases] && city_record.aliases != city[:aliases]
      city_record.aliases = city[:aliases]
      city_record.save!
      updated_count += 1
      puts "Updated aliases for city #{city[:city_name]}."
    else
      puts "City #{city[:city_name]} is already up-to-date."
    end
  else
    # New record to seed
    city_record.aliases = city[:aliases] if city[:aliases]
    city_record.save!
    seeded_count += 1
    puts "Seeded new city: #{city[:city_name]} with aliases: #{city[:aliases]}"
  end
end

total_cities = City.count
puts "*********** Seeded #{seeded_count} new cities. #{existing_count} cities already existed. #{updated_count} cities updated. Total cities in the table: #{total_cities}."
Explanation of Key Changes:
