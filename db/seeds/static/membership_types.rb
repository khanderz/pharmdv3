# frozen_string_literal: true

membership_types = [
  {
    name: 'Basic',
    description: 'Basic membership with limited features',
    price: 0.0,
    duration: 30 
  },
  {
    name: 'Pro',
    description: 'Pro membership with additional features',
    price: 19.99,
    duration: 30
  },
  {
    name: 'Premium',
    description: 'Premium membership with all features',
    price: 49.99,
    duration: 30
  }
]

seeded_count = 0
existing_count = 0
updated_count = 0

membership_types.each do |membership|
  membership_record = MembershipType.find_or_initialize_by(name: membership[:name])

  if membership_record.persisted?
    existing_count += 1
    updates_made = false

    if membership_record.description != membership[:description]
      membership_record.description = membership[:description]
      updates_made = true
      puts "Updated description for membership type #{membership[:name]}."
    end

    if membership_record.price != membership[:price]
      membership_record.price = membership[:price]
      updates_made = true
      puts "Updated price for membership type #{membership[:name]}."
    end

    if membership_record.duration != membership[:duration]
      membership_record.duration = membership[:duration]
      updates_made = true
      puts "Updated duration for membership type #{membership[:name]}."
    end

    if updates_made
      membership_record.save!
      updated_count += 1
      puts "Membership type #{membership[:name]} updated in the database."
    else
      puts "Membership type #{membership[:name]} is already up-to-date."
    end
  else
    membership_record.description = membership[:description]
    membership_record.price = membership[:price]
    membership_record.duration = membership[:duration]
    membership_record.save!
    seeded_count += 1
    puts "Seeded new membership type: #{membership[:name]}"
  end
end

total_membership_types = MembershipType.count
puts "*********** Seeded #{seeded_count} new membership types. #{existing_count} membership types already existed. #{updated_count} membership types updated. Total membership types in the table: #{total_membership_types}."
