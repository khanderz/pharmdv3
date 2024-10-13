# db/seeds/company_types.rb
CompanyType.find_or_create_by(key: 'PHARMA', value: 'Pharmacy')
CompanyType.find_or_create_by(key: 'DIGITAL_HEALTH', value: 'Digital Health')
CompanyType.find_or_create_by(key: 'OTHER', value: 'Other')

puts "Seeded Company Types"
