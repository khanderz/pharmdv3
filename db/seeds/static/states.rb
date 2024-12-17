# frozen_string_literal: true

states = [
  { state_code: 'AL', state_name: 'Alabama', country_code: 'US' },
  { state_code: 'AK', state_name: 'Alaska', country_code: 'US' },
  { state_code: 'AZ', state_name: 'Arizona', country_code: 'US' },
  { state_code: 'AR', state_name: 'Arkansas', country_code: 'US' },
  { state_code: 'CA', state_name: 'California', country_code: 'US' },
  { state_code: 'CO', state_name: 'Colorado', country_code: 'US' },
  { state_code: 'CT', state_name: 'Connecticut', country_code: 'US' },
  { state_code: 'DE', state_name: 'Delaware', country_code: 'US' },
  { state_code: 'FL', state_name: 'Florida', country_code: 'US' },
  { state_code: 'GA', state_name: 'Georgia', country_code: 'US' },
  { state_code: 'HI', state_name: 'Hawaii', country_code: 'US' },
  { state_code: 'ID', state_name: 'Idaho', country_code: 'US' },
  { state_code: 'IL', state_name: 'Illinois', country_code: 'US' },
  { state_code: 'IN', state_name: 'Indiana', country_code: 'US' },
  { state_code: 'IA', state_name: 'Iowa', country_code: 'US' },
  { state_code: 'KS', state_name: 'Kansas', country_code: 'US' },
  { state_code: 'KY', state_name: 'Kentucky', country_code: 'US' },
  { state_code: 'LA', state_name: 'Louisiana', country_code: 'US' },
  { state_code: 'ME', state_name: 'Maine', country_code: 'US' },
  { state_code: 'MD', state_name: 'Maryland', country_code: 'US' },
  { state_code: 'MA', state_name: 'Massachusetts', country_code: 'US' },
  { state_code: 'MI', state_name: 'Michigan', country_code: 'US' },
  { state_code: 'MN', state_name: 'Minnesota', country_code: 'US' },
  { state_code: 'MS', state_name: 'Mississippi', country_code: 'US' },
  { state_code: 'MO', state_name: 'Missouri', country_code: 'US' },
  { state_code: 'MT', state_name: 'Montana', country_code: 'US' },
  { state_code: 'NE', state_name: 'Nebraska', country_code: 'US' },
  { state_code: 'NV', state_name: 'Nevada', country_code: 'US' },
  { state_code: 'NH', state_name: 'New Hampshire', country_code: 'US' },
  { state_code: 'NJ', state_name: 'New Jersey', country_code: 'US' },
  { state_code: 'NM', state_name: 'New Mexico', country_code: 'US' },
  { state_code: 'NY', state_name: 'New York', country_code: 'US' },
  { state_code: 'NC', state_name: 'North Carolina', country_code: 'US' },
  { state_code: 'ND', state_name: 'North Dakota', country_code: 'US' },
  { state_code: 'OH', state_name: 'Ohio', country_code: 'US' },
  { state_code: 'OK', state_name: 'Oklahoma', country_code: 'US' },
  { state_code: 'OR', state_name: 'Oregon', country_code: 'US' },
  { state_code: 'PA', state_name: 'Pennsylvania', country_code: 'US' },
  { state_code: 'RI', state_name: 'Rhode Island', country_code: 'US' },
  { state_code: 'SC', state_name: 'South Carolina', country_code: 'US' },
  { state_code: 'SD', state_name: 'South Dakota', country_code: 'US' },
  { state_code: 'TN', state_name: 'Tennessee', country_code: 'US' },
  { state_code: 'TX', state_name: 'Texas', country_code: 'US' },
  { state_code: 'UT', state_name: 'Utah', country_code: 'US' },
  { state_code: 'VT', state_name: 'Vermont', country_code: 'US' },
  { state_code: 'VA', state_name: 'Virginia', country_code: 'US' },
  { state_code: 'WA', state_name: 'Washington', country_code: 'US' },
  { state_code: 'WV', state_name: 'West Virginia', country_code: 'US' },
  { state_code: 'WI', state_name: 'Wisconsin', country_code: 'US' },
  { state_code: 'WY', state_name: 'Wyoming', country_code: 'US' }
]

canadian_provinces = [
  { state_code: 'AB', state_name: 'Alberta', country_code: 'CA' },
  { state_code: 'BC', state_name: 'British Columbia', country_code: 'CA' },
  { state_code: 'MB', state_name: 'Manitoba', country_code: 'CA' },
  { state_code: 'NB', state_name: 'New Brunswick', country_code: 'CA' },
  { state_code: 'NL', state_name: 'Newfoundland and Labrador', country_code: 'CA' },
  { state_code: 'NS', state_name: 'Nova Scotia', country_code: 'CA' },
  { state_code: 'ON', state_name: 'Ontario', country_code: 'CA' },
  { state_code: 'PE', state_name: 'Prince Edward Island', country_code: 'CA' },
  { state_code: 'QC', state_name: 'Quebec', country_code: 'CA' },
  { state_code: 'SK', state_name: 'Saskatchewan', country_code: 'CA' },
  { state_code: 'NT', state_name: 'Northwest Territories', country_code: 'CA' },
  { state_code: 'NU', state_name: 'Nunavut', country_code: 'CA' },
  { state_code: 'YT', state_name: 'Yukon', country_code: 'CA' }
]

all_states = states + canadian_provinces

seeded_count = 0
existing_count = 0
State.count

all_states.each do |state|
  state_record = State.find_or_initialize_by(
    state_code: state[:state_code],
    state_name: state[:state_name]
  )

  state_record.country_code = state[:country_code]

  if state_record.persisted?
    existing_count += 1
  else
    state_record.save!
    seeded_count += 1
  end
  
rescue StandardError => e
  puts "Error seeding state: #{state[:state_name]} - #{e.message}"
end

total_states_after = State.count

puts "*******Seeded #{seeded_count} new states. #{existing_count} states already existed. Total states in the table: #{total_states_after}."
