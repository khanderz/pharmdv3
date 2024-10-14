# Seeding popular states in the United States for business and startups
states = [
  { state_code: 'AZ', state_name: 'Arizona' },
  { state_code: 'CA', state_name: 'California' },
  { state_code: 'CO', state_name: 'Colorado' },
  { state_code: 'FL', state_name: 'Florida' },
  { state_code: 'GA', state_name: 'Georgia' },
  { state_code: 'IL', state_name: 'Illinois' },
  { state_code: 'MA', state_name: 'Massachusetts' },
  { state_code: 'MI', state_name: 'Michigan' },
  { state_code: 'MN', state_name: 'Minnesota' },
  { state_code: 'NC', state_name: 'North Carolina' },
  { state_code: 'NJ', state_name: 'New Jersey' },
  { state_code: 'NV', state_name: 'Nevada' },
  { state_code: 'NY', state_name: 'New York' },
  { state_code: 'OH', state_name: 'Ohio' },
  { state_code: 'OR', state_name: 'Oregon' },
  { state_code: 'PA', state_name: 'Pennsylvania' },
  { state_code: 'TX', state_name: 'Texas' },
  { state_code: 'VA', state_name: 'Virginia' },
  { state_code: 'WA', state_name: 'Washington' }
]

states.each do |state|
  begin
    State.find_or_create_by!(state_code: state[:state_code], state_name: state[:state_name])
  rescue StandardError => e
    puts "Error seeding state: #{state[:state_name]} - #{e.message}"
  end
end

puts "***********Seeded popular states in the United States for business and startups"
