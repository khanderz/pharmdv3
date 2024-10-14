# Seeding common healthcare domains
healthcare_domains = [
  { key: 'BEHAVIORAL_HEALTH', value: 'Behavioral Health' },
  { key: 'CARDIOLOGY', value: 'Cardiology' },
  { key: 'DENTAL', value: 'Dental' },
  { key: 'DERMATOLOGY', value: 'Dermatology' },
  { key: 'DIGITAL_HEALTH', value: 'Digital Health' },
  { key: 'EMERGENCY_MEDICINE', value: 'Emergency Medicine' },
  { key: 'GERIATRICS', value: 'Geriatrics' },
  { key: 'NEUROLOGY', value: 'Neurology' },
  { key: 'NURSING', value: 'Nursing' },
  { key: 'OBSTETRICS', value: 'Obstetrics' },
  { key: 'ONCOLOGY', value: 'Oncology' },
  { key: 'OPTOMETRY', value: 'Optometry' },
  { key: 'PATHOLOGY', value: 'Pathology' },
  { key: 'PEDIATRICS', value: 'Pediatrics' },
  { key: 'PHARMA', value: 'Pharmaceuticals' },
  { key: 'PHYSICAL_THERAPY', value: 'Physical Therapy' },
  { key: 'PODIATRY', value: 'Podiatry' },
  { key: 'PRIMARY_CARE', value: 'Primary Care' },
  { key: 'PSYCHIATRY', value: 'Psychiatry' },
  { key: 'PUBLIC_HEALTH', value: 'Public Health' },
  { key: 'RADIOLOGY', value: 'Radiology' },
  { key: 'RESPIRATORY', value: 'Respiratory' },
  { key: 'REHABILITATION', value: 'Rehabilitation' },
  { key: 'SPEECH_THERAPY', value: 'Speech-Language Pathology' },
  { key: 'SURGERY', value: 'Surgery' }
]

healthcare_domains.each do |domain|
  begin
    HealthcareDomain.find_or_create_by!(key: domain[:key], value: domain[:value])
  rescue StandardError => e
    puts "Error seeding healthcare domain: #{domain[:key]} - #{e.message}"
  end
end

puts "*******Seeded common healthcare domains"
