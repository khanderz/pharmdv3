# frozen_string_literal: true

healthcare_domains = [
  { key: 'ALLERGY_IMMUNOLOGY', value: 'Allergy and Immunology',
    aliases: ['allergy care', 'immune health', 'immunotherapy'] },
  { key: 'CARDIOLOGY', value: 'Cardiology', aliases: ['heart health', 'cardiac care', 'cardiovascular health'] },
  { key: 'DENTAL', value: 'Dental', aliases: ['dentistry', 'oral health', 'orthodontics'] },
  { key: 'DERMATOLOGY', value: 'Dermatology', aliases: ['skin health', 'skin care', 'dermatological services'] },
  { key: 'DIGITAL_HEALTH', value: 'Digital Health', aliases: ['telemedicine', 'virtual care', 'e-health'] },
  { key: 'EMERGENCY_MEDICINE', value: 'Emergency Medicine', aliases: ['urgent care', 'emergency services', 'ER'] },
  { key: 'ENDOCRINOLOGY', value: 'Endocrinology', aliases: ['hormone health', 'diabetes care', 'metabolic health'] },
  { key: 'ENT', value: 'Ear, Nose, and Throat',
    aliases: ['ENT care', 'otolaryngology', 'head and neck health', 'hearing health', 'hearing care', 'auditory health'] },
  { key: 'EPIDEMIOLOGY', value: 'Epidemiology',
    aliases: ['disease control', 'public health', 'epidemiological studies', 'community health', 'health education', 'population health'] },
  { key: 'ENVIRONMENTAL HEALTH', value: 'Environmental Health',
    aliases: ['environmental health', 'environmental medicine', 'environmental science'] },
  { key: 'GASTROENTEROLOGY', value: 'Gastroenterology',
    aliases: ['digestive health', 'GI health', 'gastrointestinal health'] },
  { key: 'GENETICS', value: 'Genetics',
    aliases: ['genomics', 'gene therapy', 'genetic counseling', 'genomic health', 'gene therapy'] },
  { key: 'GERIATRICS', value: 'Geriatrics', aliases: ['elder care', 'senior health', 'geriatric services'] },
  { key: 'HEMATOLOGY', value: 'Hematology', aliases: ['blood health', 'hematologic care', 'anemia treatment'] },
  { key: 'INFECTIOUS_DISEASE', value: 'Infectious Disease',
    aliases: ['infectious care', 'epidemiology', 'disease prevention'] },
  { key: 'NEPHROLOGY', value: 'Nephrology', aliases: ['kidney health', 'renal care', 'nephrology services'] },
  { key: 'NEUROLOGY', value: 'Neurology', aliases: ['brain health', 'neurological care', 'neuroscience'] },
  { key: 'NURSING', value: 'Nursing', aliases: ['nurse care', 'nursing services', 'RN', 'nurse practitioners'] },
  { key: 'OBSTETRICS', value: 'Obstetrics', aliases: ['maternity care', 'prenatal care', 'pregnancy health'] },
  { key: 'ONCOLOGY', value: 'Oncology',
    aliases: ['cancer care', 'oncological services', 'cancer treatment', 'chemotherapy'] },
  { key: 'OPTOMETRY', value: 'Optometry',
    aliases: ['eye care', 'vision health', 'ophthalmology', 'eye health', 'vision health', 'ocular health', 'glasses'] },
  { key: 'ORTHOPEDICS', value: 'Orthopedics', aliases: ['bone health', 'musculoskeletal care', 'orthopedic services'] },
  { key: 'PATHOLOGY', value: 'Pathology', aliases: ['disease diagnosis', 'laboratory testing', 'clinical pathology'] },
  { key: 'PEDIATRICS', value: 'Pediatrics', aliases: ['child health', 'pediatric care', 'childcare services'] },
  { key: 'PHARMA', value: 'Pharmaceuticals',
    aliases: ['pharmacy', 'medication', 'drug development', 'pharmacology', 'medicinal chemistry'] },
  { key: 'PHYSICAL_THERAPY', value: 'Physical Therapy',
    aliases: ['physiotherapy', 'rehabilitation therapy', 'movement therapy', 'recovery services', 'rehab', 'post-surgery therapy', 'rehabilitation'] },
  { key: 'PODIATRY', value: 'Podiatry', aliases: ['foot care', 'podiatric services', 'foot health'] },
  { key: 'PRIMARY_CARE', value: 'Primary Care', aliases: ['general health', 'family medicine', 'primary health'] },
  { key: 'PSYCHIATRY', value: 'Psychiatry',
    aliases: ['mental health', 'behavioral health', 'psychotherapy', 'behavioral therapy', 'psychiatric care', 'mental health treatment', 'therapy'] },
  { key: 'PULMONOLOGY', value: 'Pulmonology',
    aliases: ['lung health', 'respiratory health', 'COPD treatment', 'pulmonary care', 'respiratory therapy'] },
  { key: 'RADIOLOGY', value: 'Radiology', aliases: ['imaging', 'medical imaging', 'diagnostic imaging'] },
  { key: 'REPRODUCTIVE_HEALTH', value: 'Reproductive Health',
    aliases: ['fertility health', 'family planning', 'reproductive medicine'] },
  { key: 'RESEARCH', value: 'Research', aliases: ['clinical research', 'medical studies', 'biomedical research'] },
  { key: 'RHEUMATOLOGY', value: 'Rheumatology', aliases: ['joint health', 'autoimmune diseases', 'rheumatic care'] },
  { key: 'SLEEP_HEALTH', value: 'Sleep Health', aliases: ['sleep health', 'sleep disorders', 'insomnia treatment'] },
  { key: 'SPEECH_THERAPY', value: 'Speech-Language Pathology',
    aliases: ['speech therapy', 'language therapy', 'communication therapy'] },
  { key: 'SURGERY', value: 'Surgery', aliases: ['surgical services', 'operative care', 'surgical procedures'] },
  { key: 'UROLOGY', value: 'Urology', aliases: ['urinary health', 'kidney health', 'urological care'] }
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
