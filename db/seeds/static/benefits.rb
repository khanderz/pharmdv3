# frozen_string_literal: true

benefits = [
  { benefit_name: 'Medical Insurance', benefit_category: 'WELLNESS', aliases: ['Health Insurance', 'Healthcare'] },
  { benefit_name: 'Dental Insurance', benefit_category: 'WELLNESS', aliases: ['Dental Coverage'] },
  { benefit_name: 'Vision Insurance', benefit_category: 'WELLNESS', aliases: ['Vision Coverage'] },
  { benefit_name: '401k Match', benefit_category: 'RETIREMENT', aliases: ['Retirement Plan', 'Pension Match'] },
  { benefit_name: 'Parental Leave', benefit_category: 'PARENTAL', aliases: ['Maternity Leave', 'Paternity Leave'] },
  { benefit_name: 'Flexible Hours', benefit_category: 'WORK_LIFE_BALANCE', aliases: ['Flexible Scheduling'] },
  { benefit_name: 'Remote Work', benefit_category: 'WORK_LIFE_BALANCE', aliases: ['Work From Home'] },
  { benefit_name: 'Professional Development', benefit_category: 'PROFESSIONAL_DEVELOPMENT', aliases: ['Training Budget', 'Conference Budget'] },
  { benefit_name: 'Wellness Programs', benefit_category: 'WELLNESS', aliases: ['Gym Membership', 'Mental Health Support'] },
  { benefit_name: 'Paid Time Off', benefit_category: 'WORK_LIFE_BALANCE', aliases: ['Vacation Days', 'PTO'] },
  { benefit_name: 'Stock Options', benefit_category: 'ADDITIONAL_PERKS', aliases: ['Equity', 'Shares'] },
  { benefit_name: 'Commuter Benefits', benefit_category: 'ADDITIONAL_PERKS', aliases: ['Transit Reimbursement'] },
  { benefit_name: 'Visa Sponsorship', benefit_category: 'VISA_SPONSORSHIP', aliases: ['Work Visa Support'] }
]

seeded_count = 0
existing_count = 0
updated_count = 0

benefits.each do |benefit|
  benefit_record = Benefit.find_or_initialize_by(benefit_name: benefit[:benefit_name])

  if benefit_record.persisted?
    existing_count += 1
    updates_made = false

    if benefit_record.benefit_category != benefit[:benefit_category]
      benefit_record.benefit_category = benefit[:benefit_category]
      updates_made = true
      puts "Updated benefit category for #{benefit[:benefit_name]} to #{benefit[:benefit_category]}."
    end

    if benefit_record.aliases != benefit[:aliases]
      benefit_record.aliases = benefit[:aliases]
      updates_made = true
      puts "Updated aliases for #{benefit[:benefit_name]} to #{benefit[:aliases].join(', ')}."
    end

    if updates_made
      benefit_record.save!
      updated_count += 1
      puts "Benefit #{benefit[:benefit_name]} updated in the database."
    else
      puts "Benefit #{benefit[:benefit_name]} is already up-to-date."
    end
  else
    benefit_record.benefit_category = benefit[:benefit_category]
    benefit_record.aliases = benefit[:aliases]
    benefit_record.save!
    seeded_count += 1
    puts "Seeded new benefit: #{benefit[:benefit_name]}"
  end
rescue StandardError => e
  puts "Error seeding benefit: #{benefit[:benefit_name]} - #{e.message}"
end

total_benefits_after = Benefit.count
puts "*********** Seeded #{seeded_count} new benefits. #{existing_count} benefits already existed. #{updated_count} benefits updated. Total benefits in the table: #{total_benefits_after}."
