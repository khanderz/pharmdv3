# frozen_string_literal: true

healthcare_domains = [
  { key: 'ALLERGY_IMMUNOLOGY', value: 'Allergy and Immunology',
    aliases: %w[allergy immune immunotherapy] },
  { key: 'CARDIOLOGY', value: 'Cardiology', aliases: %w[heart cardiac cardiovascular] },
  { key: 'DENTAL', value: 'Dental', aliases: %w[dentistry oral teeth orthodontics dental] },
  { key: 'DERMATOLOGY', value: 'Dermatology', aliases: %w[skin skincare dermatological dermatology] },
  { key: 'DIGITAL_HEALTH', value: 'Digital Health', aliases: %w[telemedicine virtual e-health telehealth] },
  { key: 'EMERGENCY_MEDICINE', value: 'Emergency Medicine', aliases: %w[urgent emergency ER] },
  { key: 'ENDOCRINOLOGY', value: 'Endocrinology',
    aliases: ['hormone health', 'diabetes', 'metabolic', 'diabetic', 'insulin'] },
  { key: 'ENT', value: 'Ear, Nose, and Throat',
    aliases: ['ENT care', 'otolaryngology', 'head and neck', 'hearing', 'auditory', 'nasal', 'throat'] },
  { key: 'EPIDEMIOLOGY', value: 'Epidemiology',
    aliases: ['disease control', 'public health', 'epidemiological', 'community health', 'health education', 'population health'] },
  { key: 'ENVIRONMENTAL HEALTH', value: 'Environmental Health',
    aliases: ['environmental', 'environmental medicine', 'environmental science'] },
  { key: 'GASTROENTEROLOGY', value: 'Gastroenterology',
    aliases: ['digestive', 'GI', 'gastrointestinal health'] },
  { key: 'GENETICS', value: 'Genetics',
    aliases: ['genomics', 'gene therapy', 'genetic counseling', 'genomic', 'gene'] },
  { key: 'GERIATRICS', value: 'Geriatrics', aliases: %w[elder elderly senior geriatric] },
  { key: 'HEMATOLOGY', value: 'Hematology', aliases: %w[blood hematologic anemia hematology] },
  { key: 'INFECTIOUS_DISEASE', value: 'Infectious Disease',
    aliases: ['infectious', 'epidemiology', 'disease prevention'] },
  { key: 'NEPHROLOGY', value: 'Nephrology', aliases: %w[kidney renal nephrology] },
  { key: 'NEUROLOGY', value: 'Neurology', aliases: %w[brain neurological neuroscience] },
  { key: 'NURSING', value: 'Nursing', aliases: ['nurse', 'nursing', 'RN', 'nurse practitioners'] },
  { key: 'OBSTETRICS', value: 'Obstetrics', aliases: %w[maternity prenatal pregnancy pregnant] },
  { key: 'ONCOLOGY', value: 'Oncology',
    aliases: ['cancer', 'oncological', 'cancer treatment', 'chemotherapy', 'chemo'] },
  { key: 'OPTOMETRY', value: 'Optometry',
    aliases: ['eye care', 'vision health', 'ophthalmology', 'eye', 'eyes', 'vision', 'ocular', 'glasses'] },
  { key: 'ORTHOPEDICS', value: 'Orthopedics', aliases: %w[bone bones musculoskeletal orthopedic] },
  { key: 'PATHOLOGY', value: 'Pathology',
    aliases: ['disease diagnosis', 'diagnosis', 'testing', 'lab', 'laboratory', 'pathology'] },
  { key: 'PEDIATRICS', value: 'Pediatrics', aliases: %w[child pediatric childcare children] },
  { key: 'PHARMA', value: 'Pharmaceuticals',
    aliases: ['pharmacy', 'medication', 'drug development', 'pharmacology', 'medicinal chemistry', 'drug'] },
  { key: 'PHYSICAL_THERAPY', value: 'Physical Therapy',
    aliases: %w[physiotherapy rehabilitation movement recovery rehab post-surgery rehabilitation] },
  { key: 'PODIATRY', value: 'Podiatry', aliases: %w[foot podiatric feet] },
  { key: 'PRIMARY_CARE', value: 'Primary Care', aliases: ['general health', 'family', 'primary health', 'primary'] },
  { key: 'PSYCHIATRY', value: 'Psychiatry',
    aliases: ['mental health', 'behavioral health', 'psychotherapy', 'behavioral therapy', 'psychiatric care', 'mental health treatment', 'therapy'] },
  { key: 'PULMONOLOGY', value: 'Pulmonology',
    aliases: ['lung health', 'respiratory health', 'COPD', 'pulmonary', 'respiratory'] },
  { key: 'RADIOLOGY', value: 'Radiology', aliases: ['imaging', 'medical imaging', 'diagnostic imaging', 'x-ray'] },
  { key: 'REPRODUCTIVE_HEALTH', value: 'Reproductive Health',
    aliases: ['fertility', 'family planning', 'reproductive'] },
  { key: 'RESEARCH', value: 'Research',
    aliases: ['clinical research', 'medical studies', 'biomedical research', 'biomedical', 'research'] },
  { key: 'RHEUMATOLOGY', value: 'Rheumatology', aliases: ['joint health', 'autoimmune', 'rheumatic'] },
  { key: 'SLEEP_HEALTH', value: 'Sleep Health', aliases: ['sleep health', 'sleep disorders', 'insomnia', 'sleep'] },
  { key: 'SPEECH_THERAPY', value: 'Speech-Language Pathology',
    aliases: %w[speech language communication] },
  { key: 'SURGERY', value: 'Surgery', aliases: %w[surgical operative procedures surgery] },
  { key: 'UROLOGY', value: 'Urology', aliases: %w[urinary kidney urological] }
]

seeded_count = 0
existing_count = 0
updated_count = 0

healthcare_domains.each do |domain|
  domain_record = HealthcareDomain.find_or_initialize_by(key: domain[:key])

  if domain_record.persisted?
    existing_count += 1
    updates_made = false

    # Check if `value` or `aliases` need updating
    if domain_record.value != domain[:value]
      domain_record.value = domain[:value]
      updates_made = true
      puts "Updated value for domain #{domain[:key]}."
    end

    if domain_record.aliases != domain[:aliases]
      domain_record.aliases = domain[:aliases]
      updates_made = true
      puts "Updated aliases for domain #{domain[:key]}."
    end

    if updates_made
      domain_record.save!
      updated_count += 1
      puts "Domain #{domain[:key]} updated in database."
    else
      puts "Domain #{domain[:key]} already up-to-date."
    end
  else
    # New record to seed
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
puts "*******Seeded #{seeded_count} new healthcare domains. #{existing_count} domains already existed. #{updated_count} domains updated. Total domains in the table: #{total_domains_after}."
