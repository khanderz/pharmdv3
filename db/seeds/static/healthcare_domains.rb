# frozen_string_literal: true

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
  { key: 'RESEARCH', value: 'Research' },
  { key: 'RESPIRATORY', value: 'Respiratory' },
  { key: 'REHABILITATION', value: 'Rehabilitation' },
  { key: 'SPEECH_THERAPY', value: 'Speech-Language Pathology' },
  { key: 'SURGERY', value: 'Surgery' }
]

seeded_count = 0
existing_count = 0
HealthcareDomain.count

healthcare_domains.each do |domain|
  domain_record = HealthcareDomain.find_or_initialize_by(key: domain[:key])

  if domain_record.persisted?
    existing_count += 1
    puts "Domain #{domain[:key]} already exists."
  else
    domain_record.value = domain[:value]
    domain_record.save!
    seeded_count += 1
    puts "Seeded new domain: #{domain[:key]} - #{domain[:value]}"
  end
rescue StandardError => e
  puts "Error seeding healthcare domain: #{domain[:key]} - #{e.message}"
end

total_domains_after = HealthcareDomain.count

puts "*******Seeded #{seeded_count} new healthcare domains. #{existing_count} domains already existed. Total domains in the table: #{total_domains_after}."
