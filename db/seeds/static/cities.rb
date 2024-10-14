# Seeding popular cities in the United States for business districts and startups, including aliases for neighborhoods or districts
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
  { city_name: 'Los Angeles', aliases: ['Hollywood', 'Santa Monica', 'Beverly Hills', 'Venice', 'Downtown LA', 'Westwood', 'Silver Lake'] },
  { city_name: 'Miami', aliases: ['Brickell', 'Wynwood', 'Little Havana', 'Coconut Grove', 'South Beach'] },
  { city_name: 'Minneapolis' },
  { city_name: 'New York', aliases: ['Manhattan', 'Brooklyn', 'Queens', 'Bronx', 'Staten Island', 'Harlem', 'SoHo', 'Tribeca', 'Chelsea'] },
  { city_name: 'Palo Alto' },
  { city_name: 'Philadelphia' },
  { city_name: 'Pittsburgh' },
  { city_name: 'Portland' },
  { city_name: 'Raleigh' },
  { city_name: 'Salt Lake City' },
  { city_name: 'San Francisco', aliases: ['SOMA', 'Mission District', 'Financial District', 'Nob Hill', 'Castro', 'Pacific Heights'] },
  { city_name: 'San Jose' },
  { city_name: 'Seattle', aliases: ['Capitol Hill', 'Belltown', 'Ballard', 'Fremont', 'Queen Anne', 'South Lake Union'] },
  { city_name: 'Washington', aliases: ['Georgetown', 'Dupont Circle', 'Capitol Hill', 'Foggy Bottom', 'Adams Morgan', 'Columbia Heights'] }
]

cities.each do |city|
  begin
    City.find_or_create_by!(city_name: city[:city_name], aliases: city[:aliases])
  rescue StandardError => e
    puts "Error seeding city: #{city[:city_name]} - #{e.message}"
  end
end

puts "***********Seeded popular cities in the United States with aliases for neighborhoods and districts."
