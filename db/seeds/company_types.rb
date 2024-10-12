company_types = CompanyType.create([
  { key: 'PHARMA', value: 'Pharmacy' },
  { key: 'DIGITAL_HEALTH', value: 'Digital Health' },
  { key: 'OTHER', value: 'Other' }
])

company_types.each do |company_type|
  puts "Seeded CompanyType: #{company_type.key} - #{company_type.value}"
end
