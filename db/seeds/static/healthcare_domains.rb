# frozen_string_literal: true

# Seeding common healthcare domains with aliases
healthcare_domains = [
  { key: 'BEHAVIORAL_HEALTH', value: 'Behavioral Health', aliases: ['mental health', 'behavioral therapy', 'psychiatric care'] },
  { key: 'CARDIOLOGY', value: 'Cardiology', aliases: ['heart health', 'cardiac care', 'cardiac health'] },
  { key: 'DENTAL', value: 'Dental', aliases: ['dentistry', 'oral health', 'orthodontics'] },
  { key: 'DERMATOLOGY', value: 'Dermatology', aliases: ['skin health', 'skin care', 'dermatological services'] },
  { key: 'DIGITAL_HEALTH', value: 'Digital Health', aliases: ['telemedicine', 'virtual care', 'e-health'] },
  { key: 'EMERGENCY_MEDICINE', value: 'Emergency Medicine', aliases: ['urgent care', 'emergency services', 'ER'] },
  { key: 'GERIATRICS', value: 'Geriatrics', aliases: ['elder care', 'senior health', 'geriatric services'] },
  { key: 'NEUROLOGY', value: 'Neurology', aliases: ['brain health', 'neurological care', 'neuroscience'] },
  { key: 'NURSING', value: 'Nursing', aliases: ['nurse care', 'nursing services', 'RN'] },
  { key: 'OBSTETRICS', value: 'Obstetrics', aliases: ['maternity care', 'prenatal care', 'pregnancy health'] },
  { key: 'ONCOLOGY', value: 'Oncology', aliases: ['cancer care', 'oncological services', 'cancer treatment'] },
  { key: 'OPTOMETRY', value: 'Optometry', aliases: ['eye care', 'vision health', 'ophthalmology'] },
  { key: 'PATHOLOGY', value: 'Pathology', aliases: ['disease diagnosis', 'laboratory testing', 'clinical pathology'] },
  { key: 'PEDIATRICS', value: 'Pediatrics', aliases: ['child health', 'pediatric care', 'child care services'] },
  { key: 'PHARMA', value: 'Pharmaceuticals', aliases: ['pharma', 'medication', 'drug development'] },
  { key: 'PHYSICAL_THERAPY', value: 'Physical Therapy', aliases: ['physiotherapy', 'rehabilitation therapy', 'movement therapy'] },
  { key: 'PODIATRY', value: 'Podiatry', aliases: ['foot care', 'podiatric services', 'foot health'] },
  { key: 'PRIMARY_CARE', value: 'Primary Care', aliases: ['general health', 'family medicine', 'primary health'] },
  { key: 'PSYCHIATRY', value: 'Psychiatry', aliases: ['mental health treatment', 'psychiatric services', 'psychotherapy'] },
  { key: 'PUBLIC_HEALTH', value: 'Public Health', aliases: ['community health', 'health education', 'population health'] },
  { key: 'RADIOLOGY', value: 'Radiology', aliases: ['imaging', 'medical imaging', 'x-ray services'] },
  { key: 'RESEARCH', value: 'Research', aliases: ['clinical research', 'medical studies', 'biomedical research'] },
  { key: 'RESPIRATORY', value: 'Respiratory', aliases: ['lung health', 'pulmonary care', 'respiratory therapy'] },
  { key: 'REHABILITATION', value: 'Rehabilitation', aliases: ['recovery services', 'rehab', 'post-surgery therapy'] },
  { key: 'SPEECH_THERAPY', value: 'Speech-Language Pathology', aliases: ['speech therapy', 'language therapy', 'communication therapy'] },
  { key: 'SURGERY', value: 'Surgery', aliases: ['surgical services', 'operative care', 'surgical procedures'] }
]

seeded_count = 0
existing_count = 0

healthcare_domains.each do |domain|
  domain_record = HealthcareDomain.find_or_initialize_by(key: domain[:key])

  if domain_record.persisted?
    existing_count += 1
    puts "Domain #{domain[:key]} already exists."
  else
    domain_record.value = domain[:value]
    domain_record.aliases = domain[:aliases]
    domain_record.save!
    seeded_count += 1
    puts "Seeded new domain: #{domain[:key]} - #{domain[:value]} with aliases: #{domain[:aliases]}"
  end
rescue StandardError => e
  puts "Error seeding healthcare domain: #{domain[:key]} - #{e.message}"
end

total_domains_after = HealthcareDomain.count
puts "*******Seeded #{seeded_count} new healthcare domains. #{existing_count} domains already existed. Total domains in the table: #{total_domains_after}."
