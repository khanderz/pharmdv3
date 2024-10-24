# Seeding all states in the United States
states = [
  { state_code: 'AL', state_name: 'Alabama' },
  { state_code: 'AK', state_name: 'Alaska' },
  { state_code: 'AZ', state_name: 'Arizona' },
  { state_code: 'AR', state_name: 'Arkansas' },
  { state_code: 'CA', state_name: 'California' },
  { state_code: 'CO', state_name: 'Colorado' },
  { state_code: 'CT', state_name: 'Connecticut' },
  { state_code: 'DE', state_name: 'Delaware' },
  { state_code: 'FL', state_name: 'Florida' },
  { state_code: 'GA', state_name: 'Georgia' },
  { state_code: 'HI', state_name: 'Hawaii' },
  { state_code: 'ID', state_name: 'Idaho' },
  { state_code: 'IL', state_name: 'Illinois' },
  { state_code: 'IN', state_name: 'Indiana' },
  { state_code: 'IA', state_name: 'Iowa' },
  { state_code: 'KS', state_name: 'Kansas' },
  { state_code: 'KY', state_name: 'Kentucky' },
  { state_code: 'LA', state_name: 'Louisiana' },
  { state_code: 'ME', state_name: 'Maine' },
  { state_code: 'MD', state_name: 'Maryland' },
  { state_code: 'MA', state_name: 'Massachusetts' },
  { state_code: 'MI', state_name: 'Michigan' },
  { state_code: 'MN', state_name: 'Minnesota' },
  { state_code: 'MS', state_name: 'Mississippi' },
  { state_code: 'MO', state_name: 'Missouri' },
  { state_code: 'MT', state_name: 'Montana' },
  { state_code: 'NE', state_name: 'Nebraska' },
  { state_code: 'NV', state_name: 'Nevada' },
  { state_code: 'NH', state_name: 'New Hampshire' },
  { state_code: 'NJ', state_name: 'New Jersey' },
  { state_code: 'NM', state_name: 'New Mexico' },
  { state_code: 'NY', state_name: 'New York' },
  { state_code: 'NC', state_name: 'North Carolina' },
  { state_code: 'ND', state_name: 'North Dakota' },
  { state_code: 'OH', state_name: 'Ohio' },
  { state_code: 'OK', state_name: 'Oklahoma' },
  { state_code: 'OR', state_name: 'Oregon' },
  { state_code: 'PA', state_name: 'Pennsylvania' },
  { state_code: 'RI', state_name: 'Rhode Island' },
  { state_code: 'SC', state_name: 'South Carolina' },
  { state_code: 'SD', state_name: 'South Dakota' },
  { state_code: 'TN', state_name: 'Tennessee' },
  { state_code: 'TX', state_name: 'Texas' },
  { state_code: 'UT', state_name: 'Utah' },
  { state_code: 'VT', state_name: 'Vermont' },
  { state_code: 'VA', state_name: 'Virginia' },
  { state_code: 'WA', state_name: 'Washington' },
  { state_code: 'WV', state_name: 'West Virginia' },
  { state_code: 'WI', state_name: 'Wisconsin' },
  { state_code: 'WY', state_name: 'Wyoming' }
]

seeded_count = 0
existing_count = 0
total_states = State.count

states.each do |state|
  begin
    state_record = State.find_or_initialize_by(state_code: state[:state_code], state_name: state[:state_name])
    
    if state_record.persisted?
      existing_count += 1
    else
      state_record.save!
      seeded_count += 1
    end
  rescue StandardError => e
    puts "Error seeding state: #{state[:state_name]} - #{e.message}"
  end
end

total_states_after = State.count

puts "*******Seeded #{seeded_count} new states. #{existing_count} states already existed. Total states in the table: #{total_states_after}."
