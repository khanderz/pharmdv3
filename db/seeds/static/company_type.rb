# frozen_string_literal: true

# Seeding common company types
company_types = [
  { company_type_code: 'EDUCATIONAL', company_type_name: 'Educational Institution' },
  { company_type_code: 'GOVERNMENT_AGENCY', company_type_name: 'Government Agency' },
  { company_type_code: 'NON_PROFIT', company_type_name: 'Nonprofit' },
  { company_type_code: 'PARTNERSHIP', company_type_name: 'Partnership' },
  { company_type_code: 'PRIVATELY_HELD', company_type_name: 'Privately Held' },
  { company_type_code: 'PUBLIC_COMPANY', company_type_name: 'Public Company' },
  { company_type_code: 'SELF_EMPLOYED', company_type_name: 'Self-Employed' },
  { company_type_code: 'SELF_OWNED', company_type_name: 'Sole Proprietorship' }
]

seeded_count = 0
existing_count = 0
updated_count = 0

company_types.each do |type|
  company_type_record = CompanyType.find_or_initialize_by(company_type_code: type[:company_type_code])

  if company_type_record.persisted?
    existing_count += 1
    updates_made = false

    if company_type_record.company_type_name != type[:company_type_name]
      company_type_record.company_type_name = type[:company_type_name]
      updates_made = true
      puts "Updated company_type_name for company type #{type[:company_type_code]}."
    end

    if updates_made
      company_type_record.save!
      updated_count += 1
      puts "Company type #{type[:company_type_code]} updated in database."
    else
      puts "Company type #{type[:company_type_code]} is already up-to-date."
    end
  else
    company_type_record.company_type_name = type[:company_type_name]
    company_type_record.save!
    seeded_count += 1
    puts "Seeded new company type: #{type[:company_type_code]}"
  end
end

total_company_types = CompanyType.count
puts "*********** Seeded #{seeded_count} new company types. #{existing_count} company types already existed. #{updated_count} company types updated. Total company types in the table: #{total_company_types}."
