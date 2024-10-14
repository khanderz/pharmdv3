# Seeding common healthcare domains
healthcare_domains = [
  { key: 'PHARMA', value: 'Pharmaceuticals' },
  { key: 'DIGITAL_HEALTH', value: 'Digital Health' },
  { key: 'DENTAL', value: 'Dental' },
  { key: 'OPTOMETRY', value: 'Optometry' },
  { key: 'NURSING', value: 'Nursing' },
  { key: 'PRIMARY_CARE', value: 'Primary Care' },
  { key: 'BEHAVIORAL_HEALTH', value: 'Behavioral Health' },
  { key: 'GERIATRICS', value: 'Geriatrics' },
  { key: 'PEDIATRICS', value: 'Pediatrics' },
  { key: 'REHABILITATION', value: 'Rehabilitation' },
  { key: 'CARDIOLOGY', value: 'Cardiology' },
  { key: 'NEUROLOGY', value: 'Neurology' },
  { key: 'ONCOLOGY', value: 'Oncology' },
  { key: 'OBSTETRICS', value: 'Obstetrics' },
  { key: 'PSYCHIATRY', value: 'Psychiatry' },
  { key: 'DERMATOLOGY', value: 'Dermatology' },
  { key: 'SURGERY', value: 'Surgery' },
  { key: 'PATHOLOGY', value: 'Pathology' },
  { key: 'PUBLIC_HEALTH', value: 'Public Health' }
]

healthcare_domains.each do |domain|
  begin
    HealthcareDomain.find_or_create_by!(key: domain[:key], value: domain[:value])
  rescue StandardError => e
    puts "Error seeding healthcare domain: #{domain[:key]} - #{e.message}"
  end
end

puts "*******Seeded common healthcare domains"
