# frozen_string_literal: true

#  38
domains = {
  allergy_immunology: HealthcareDomain.find_by(key: 'ALLERGY_IMMUNOLOGY'),
  cardiology: HealthcareDomain.find_by(key: 'CARDIOLOGY'),
  dental: HealthcareDomain.find_by(key: 'DENTAL'),
  dermatology: HealthcareDomain.find_by(key: 'DERMATOLOGY'),
  digital_health: HealthcareDomain.find_by(key: 'DIGITAL_HEALTH'),
  emergency_medicine: HealthcareDomain.find_by(key: 'EMERGENCY_MEDICINE'),
  endocrinology: HealthcareDomain.find_by(key: 'ENDOCRINOLOGY'),
  ent: HealthcareDomain.find_by(key: 'ENT'),
  epidemiology: HealthcareDomain.find_by(key: 'EPIDEMIOLOGY'),
  environmental_health: HealthcareDomain.find_by(key: 'ENVIRONMENTAL_HEALTH'),
  gastroenterology: HealthcareDomain.find_by(key: 'GASTROENTEROLOGY'),
  genetics: HealthcareDomain.find_by(key: 'GENETICS'),
  geriatrics: HealthcareDomain.find_by(key: 'GERIATRICS'),
  hematology: HealthcareDomain.find_by(key: 'HEMATOLOGY'),
  mens_health: HealthcareDomain.find_by(key: 'MENS_HEALTH'),
  nephrology: HealthcareDomain.find_by(key: 'NEPHROLOGY'),
  neurology: HealthcareDomain.find_by(key: 'NEUROLOGY'),
  nursing: HealthcareDomain.find_by(key: 'NURSING'),
  oncology: HealthcareDomain.find_by(key: 'ONCOLOGY'),
  optometry: HealthcareDomain.find_by(key: 'OPTOMETRY'),
  orthopedics: HealthcareDomain.find_by(key: 'ORTHOPEDICS'),
  pathology: HealthcareDomain.find_by(key: 'PATHOLOGY'),
  pediatrics: HealthcareDomain.find_by(key: 'PEDIATRICS'),
  pharma: HealthcareDomain.find_by(key: 'PHARMA'),
  physical_therapy: HealthcareDomain.find_by(key: 'PHYSICAL_THERAPY'),
  podiatry: HealthcareDomain.find_by(key: 'PODIATRY'),
  primary_care: HealthcareDomain.find_by(key: 'PRIMARY_CARE'),
  psychiatry: HealthcareDomain.find_by(key: 'PSYCHIATRY'),
  radiology: HealthcareDomain.find_by(key: 'RADIOLOGY'),
  reproductive_health: HealthcareDomain.find_by(key: 'REPRODUCTIVE_HEALTH'),
  research: HealthcareDomain.find_by(key: 'RESEARCH'),
  sleep_health: HealthcareDomain.find_by(key: 'SLEEP_HEALTH'),
  speech_therapy: HealthcareDomain.find_by(key: 'SPEECH_THERAPY'),
  surgery: HealthcareDomain.find_by(key: 'SURGERY'),
  womens_health: HealthcareDomain.find_by(key: 'WOMENS_HEALTH')
}

specialties = {
  allergy_immunology: [
    { key: 'ALLERGY_TREATMENT', value: 'Allergy Treatment',
      aliases: ['allergy care', 'immunotherapy'] },
    { key: 'IMMUNE_DISORDER_MANAGEMENT', value: 'Immune Disorder Management',
      aliases: ['autoimmune care', 'immune system health'] },
    { key: 'ARTHRITIS_MANAGEMENT', value: 'Arthritis Management',
      aliases: ['arthritis care', 'joint inflammation treatment'] },
    { key: 'AUTOIMMUNE_DISORDER_TREATMENT', value: 'Autoimmune Disorder Treatment',
      aliases: ['autoimmune care', 'immune disorder treatment'] }
  ],
  cardiology: [
    { key: 'CARDIAC_REHABILITATION', value: 'Cardiac Rehabilitation',
      aliases: ['heart rehab', 'cardiac recovery'] },
    { key: 'ELECTROPHYSIOLOGY', value: 'Electrophysiology',
      aliases: ['heart rhythm', 'arrhythmia treatment'] },
    { key: 'HEART_SURGERY', value: 'Heart Surgery',
      aliases: ['cardiac surgery', 'heart operation'] },
    { key: 'INTERVENTIONAL_CARDIOLOGY', value: 'Interventional Cardiology',
      aliases: ['catheterization', 'cardiac intervention'] }
  ],
  dental: [
    { key: 'COSMETIC_DENTISTRY', value: 'Cosmetic Dentistry',
      aliases: ['teeth whitening', 'dental aesthetics'] },
    { key: 'DENTAL_IMPLANTS', value: 'Dental Implants',
      aliases: ['teeth implants', 'dental prosthetics'] },
    { key: 'ENDODONTICS', value: 'Endodontics', aliases: ['root canal', 'tooth pulp treatment'] },
    { key: 'ORTHODONTICS', value: 'Orthodontics', aliases: ['braces', 'teeth alignment'] },
    { key: 'PEDIATRIC_DENTISTRY', value: 'Pediatric Dentistry',
      aliases: ['children’s dentistry', 'kids dental care'] }
  ],
  dermatology: [
    { key: 'ACNE_TREATMENT', value: 'Acne Treatment',
      aliases: ['pimple care', 'skin blemish treatment'] },
    { key: 'COSMETIC_DERMATOLOGY', value: 'Cosmetic Dermatology',
      aliases: ['skin aesthetics', 'dermatological aesthetics'] }
  ],
  digital_health: [
    { key: 'APP_DEPLOYMENT', value: 'App Deployment',
      aliases: ['digital app deployment', 'health app'] },
    { key: 'BILLING_AND_PAYMENTS', value: 'Billing & Payments',
      aliases: ['billing services', 'health payments'] },
    { key: 'CARE_COORDINATION_COLLABORATION', value: 'Care Coordination & Collaboration',
      aliases: ['care teamwork', 'patient coordination'] },
    { key: 'CLINICAL_INTELLIGENCE', value: 'Clinical Intelligence',
      aliases: ['AI in health', 'clinical AI'] },
    { key: 'COMPUTER_AIDED_IMAGING', value: 'Computer-Aided Imaging',
      aliases: ['image analysis', 'AI imaging'] },
    { key: 'DATA_INTEGRATION_ANALYTICS', value: 'Data Integration & Analytics',
      aliases: ['health analytics', 'data insights'] },
    { key: 'DIGITAL_THERAPEUTICS', value: 'Digital Therapeutics',
      aliases: ['digital treatment', 'online therapeutics'] },
    { key: 'HOME_HEALTH_TECH', value: 'Home Health Tech',
      aliases: ['home care tech', 'health tech'] },
    { key: 'HYBRID_VIRTUAL_INPERSON_CARE', value: 'Hybrid Virtual In-Person Care',
      aliases: ['hybrid care', 'mixed virtual in-person'] },
    { key: 'MEDIA', value: 'Media', aliases: ['health media', 'medical media'] },
    { key: 'PATIENT_ENGAGEMENT', value: 'Patient Engagement',
      aliases: ['patient interaction', 'patient comms'] },
    { key: 'PROVIDER_DIRECTORIES_AND_CARE_NAVIGATION', value: 'Provider Directories & Care Navigation',
      aliases: ['provider search', 'care directory'] },
    { key: 'REMOTE_PATIENT_MONITORING', value: 'Remote Patient Monitoring',
      aliases: ['RPM', 'patient monitoring tech'] },
    { key: 'REVENUE_CYCLE_MGMT', value: 'Revenue Cycle Management',
      aliases: ['revenue mgmt', 'financial health'] },
    { key: 'SCREENING_MONITORING_DIAGNOSTICS', value: 'Screening, Monitoring, Diagnostics',
      aliases: ['health diagnostics', 'screening tests'] },
    { key: 'VIRTUAL_CARE', value: 'Virtual Care', aliases: ['telehealth', 'remote care'] },
    { key: 'WORKFLOW_DIGITIZATION_AND_AUTOMATION', value: 'Workflow Digitization & Automation',
      aliases: ['digital workflow', 'health automation'] }
  ],
  emergency_medicine: [
    { key: 'EMERGENCY_CARE', value: 'Emergency Care', aliases: ['urgent care', 'ER services'] },
    { key: 'TRAUMA_CARE', value: 'Trauma Care', aliases: ['injury care', 'trauma treatment'] }
  ],
  endocrinology: [
    { key: 'DIABETES_MANAGEMENT', value: 'Diabetes Management',
      aliases: ['diabetes care', 'insulin therapy'] },
    { key: 'HORMONE_THERAPY', value: 'Hormone Therapy',
      aliases: ['hormone replacement', 'endocrine therapy'] }
  ],
  ent: [
    { key: 'HEARING_AIDS', value: 'Hearing Aids',
      aliases: ['hearing devices', 'hearing technology'] },
    { key: 'HEARING_TESTS', value: 'Hearing Tests',
      aliases: ['hearing evaluation', 'hearing screening'] },
    { key: 'ASTHMA_MANAGEMENT', value: 'Asthma Management',
      aliases: ['asthma care', 'asthma treatment'] },
    { key: 'COPD_CARE', value: 'COPD Care',
      aliases: ['chronic obstructive pulmonary disease', 'lung disease care'] },
    { key: 'RESPIRATORY_THERAPY', value: 'Respiratory Therapy',
      aliases: ['breathing therapy', 'lung therapy'] }
  ],
  epidemiology: [
    { key: 'DISEASE_CONTROL', value: 'Disease Control',
      aliases: ['disease prevention', 'epidemiology'] },
    { key: 'PUBLIC_HEALTH', value: 'Public Health',
      aliases: ['community health', 'health education'] },
    { key: 'ANTIVIRAL_TREATMENTS', value: 'Antiviral Treatments',
      aliases: ['antiviral therapy', 'viral care'] },
    { key: 'INFECTION_CONTROL', value: 'Infection Control',
      aliases: ['infection prevention', 'disease prevention'] }
  ],
  environmental_health: [
    { key: 'CLIMATE_CHANGE_HEALTH', value: 'Climate Change Health',
      aliases: ['climate health', 'environmental health'] },
    { key: 'ENVIRONMENTAL_MEDICINE', value: 'Environmental Medicine',
      aliases: ['environmental health', 'environmental science'] },
    { key: 'TOXICOLOGY', value: 'Toxicology', aliases: ['toxin study', 'poison control'] }
  ],
  gastroenterology: [
    { key: 'COLONOSCOPY_SERVICES', value: 'Colonoscopy Services',
      aliases: ['colon cancer screening', 'colon health'] },
    { key: 'GASTROINTESTINAL_SURGERY', value: 'Gastrointestinal Surgery',
      aliases: ['GI surgery', 'digestive surgery'] }
  ],
  genetics: [
    { key: 'GENETIC_COUNSELING', value: 'Genetic Counseling',
      aliases: ['genetic testing', 'genetic health'] },
    { key: 'GENOMIC_HEALTH', value: 'Genomic Health',
      aliases: ['genomic medicine', 'genetic health'] }
  ],
  geriatrics: [
    { key: 'ELDERLY_CARE', value: 'Elderly Care', aliases: ['senior care', 'aging health'] },
    { key: 'GERIATRIC_REHABILITATION', value: 'Geriatric Rehabilitation',
      aliases: ['senior rehab', 'elderly recovery'] }
  ],
  hematology: [
    { key: 'ANEMIA_TREATMENT', value: 'Anemia Treatment',
      aliases: ['blood disorder care', 'anemia care'] },
    { key: 'BLOOD_CANCER_TREATMENT', value: 'Blood Cancer Treatment',
      aliases: ['leukemia care', 'lymphoma care'] }
  ],
  nephrology: [
    { key: 'DIALYSIS_SERVICES', value: 'Dialysis Services',
      aliases: ['kidney dialysis', 'renal dialysis'] },
    { key: 'KIDNEY_TRANSPLANT_SERVICES ', value: 'Kidney Transplant Services',
      aliases: ['renal transplant', 'kidney surgery'] },
    { key: 'KIDNEY_HEALTH', value: 'Kidney Health', aliases: ['renal health', 'nephrology care'] },
    { key: 'PROSTATE_CARE', value: 'Prostate Care',
      aliases: ['prostate health', 'prostate disease'] }
  ],
  neurology: [
    { key: 'NEURODEGENERATIVE_DISORDER_CARE', value: 'Neurodegenerative Disorder Care',
      aliases: ['dementia care', 'Parkinson’s treatment'] },
    { key: 'NEUROREHABILITATION', value: 'Neurorehabilitation',
      aliases: ['brain injury rehab', 'neuro recovery'] }
  ],
  nursing: [
    { key: 'CRITICAL_CARE_NURSING', value: 'Critical Care Nursing',
      aliases: ['ICU nursing', 'intensive care nursing'] },
    { key: 'GERIATRIC_NURSING', value: 'Geriatric Nursing',
      aliases: ['senior nursing', 'elderly care'] },
    { key: 'HOME_HEALTHCARE', value: 'Home Healthcare', aliases: ['home nursing', 'in-home care'] },
    { key: 'PEDIATRIC_NURSING', value: 'Pediatric Nursing',
      aliases: ['child nursing', 'kids nursing'] },
    { key: 'PSYCHIATRIC_NURSING', value: 'Psychiatric Nursing',
      aliases: ['mental health nursing', 'behavioral health nursing'] }
  ],
  oncology: [
    { key: 'CHEMOTHERAPY', value: 'Chemotherapy', aliases: ['chemo', 'cancer drugs'] },
    { key: 'MEDICAL_ONCOLOGY', value: 'Medical Oncology',
      aliases: ['cancer medicine', 'oncology treatment'] },
    { key: 'RADIATION_ONCOLOGY', value: 'Radiation Oncology',
      aliases: ['radiation therapy', 'oncology radiation'] },
    { key: 'SURGICAL_ONCOLOGY', value: 'Surgical Oncology',
      aliases: ['cancer surgery', 'oncology operations'] }
  ],
  optometry: [
    { key: 'EYE_EXAMS', value: 'Eye Exams', aliases: ['vision tests', 'eye checkup'] },
    { key: 'GLASSES_CONTACTS', value: 'Glasses & Contacts',
      aliases: ['eyewear', 'vision correction'] }
  ],
  orthopedics: [
    { key: 'JOINT_REPLACEMENT', value: 'Joint Replacement',
      aliases: ['hip replacement', 'knee replacement'] },
    { key: 'SPINAL_SURGERY', value: 'Spinal Surgery', aliases: ['back surgery', 'spine care'] }
  ],
  pathology: [
    { key: 'CLINICAL_PATHOLOGY', value: 'Clinical Pathology',
      aliases: ['laboratory medicine', 'clinical labs'] },
    { key: 'FORENSIC_PATHOLOGY', value: 'Forensic Pathology',
      aliases: ['medical examiner', 'autopsy'] },
    { key: 'MOLECULAR_PATHOLOGY', value: 'Molecular Pathology',
      aliases: ['genomic pathology', 'molecular diagnostics'] }
  ],
  pediatrics: [
    { key: 'CHILD_DEVELOPMENT_SERVICES', value: 'Child Development Services',
      aliases: ['developmental care', 'child growth'] },
    { key: 'PEDIATRIC_EMERGENCY_CARE', value: 'Pediatric Emergency Care',
      aliases: ['child emergency care', 'pediatric ER'] }
  ],
  pharma: [
    { key: 'AVIATION MEDICINE', value: 'Aviation Medicine',
      aliases: ['pilot health', 'flight medicine', 'space medicine', 'aerospace medicine'] },
    { key: 'BIOPHARMACEUTICALS', value: 'Biopharmaceuticals',
      aliases: ['biologics', 'biotech drugs'] },
    { key: 'BRANDED_PHARMA', value: 'Branded Pharma',
      aliases: ['brand-name drugs', 'patented drugs'] },
    { key: 'CANNABIS_THERAPEUTICS', value: 'Cannabis Therapeutics',
      aliases: ['medical marijuana', 'cannabinoid therapy'] },
    { key: 'CHRONIC_DISEASE_MGMT', value: 'Chronic Disease Management',
      aliases: ['chronic care', 'disease management'] },
    { key: 'CHRONIC_PAIN_THERAPY', value: 'Chronic Pain Therapy',
      aliases: ['long-term pain relief', 'chronic pain care', 'opioid therapy', 'pain meds'] },
    { key: 'CLINICAL_TRIALS', value: 'Clinical Trials', aliases: ['trials', 'clinical research'] },
    { key: 'DIGITAL_THERAPEUTICS', value: 'Digital Therapeutics',
      aliases: ['e-therapy', 'digital health treatments'] },
    { key: 'DTC_PHARMACY_SERVICES', value: 'DTC Pharmacy Services',
      aliases: ['direct pharmacy', 'dtc services'] },
    { key: 'HOME_LAB_TESTING_MONITORING', value: 'Home Lab Testing & Monitoring',
      aliases: ['at-home lab', 'home testing'] },
    { key: 'HOSPITAL_PHARMACY', value: 'Hospital Pharmacy',
      aliases: ['inpatient pharmacy', 'hospital meds'] },
    { key: 'NOVEL_PHARMA', value: 'Novel Pharma',
      aliases: ['new drug development', 'novel drugs'] },
    { key: 'PERSONALIZED_PHARMACY_SERVICES', value: 'Personalized Pharmacy Services',
      aliases: ['custom pharmacy', 'personalized meds'] },
    { key: 'PHARM_SERVICES_WORKFLOW_EXPANSION', value: 'Pharm Services Workflow Expansion',
      aliases: ['pharmacy workflow', 'services expansion'] },
    { key: 'PHARMACOGENOMICS', value: 'Pharmacogenomics',
      aliases: ['gene-based drug', 'genetic therapy'] },
    { key: 'PHARMACY_MEDIA', value: 'Pharmacy Media',
      aliases: ['pharma advertising', 'pharma marketing'] },
    { key: 'VIRTUAL_PHARMACY', value: 'Virtual Pharmacy',
      aliases: ['e-pharmacy', 'online pharmacy'] },
    { key: 'VITAMINS_SUPPLEMENTS', value: 'Vitamins & Supplements',
      aliases: %w[supplements nutraceuticals] },
    { key: 'VACCINE_DEVELOPMENT', value: 'Vaccine Development',
      aliases: ['vaccine research', 'immunization'] }
  ],
  physical_therapy: [
    { key: 'AQUATIC_THERAPY', value: 'Aquatic Therapy',
      aliases: ['water therapy', 'pool therapy'] },
    { key: 'NEUROLOGICAL_REHABILITATION', value: 'Neurological Rehabilitation',
      aliases: ['brain injury rehab', 'neuro recovery'] },
    { key: 'PHYSICAL_REHABILITATION', value: 'Physical Rehabilitation',
      aliases: ['physical therapy', 'rehab therapy'] },
    { key: 'OCCUPATIONAL_THERAPY', value: 'Occupational Therapy', aliases: ['OT', 'skill rehab'] }
  ],
  podiatry: [
    { key: 'FOOT_SURGERY', value: 'Foot Surgery',
      aliases: ['foot operation', 'podiatric surgery'] },
    { key: 'ORTHOTICS_PROSTHETICS', value: 'Orthotics & Prosthetics',
      aliases: ['foot devices', 'foot support'] }
  ],
  primary_care: [
    { key: 'FAMILY_MEDICINE', value: 'Family Medicine',
      aliases: ['family doctor', 'general practitioner'] },
    { key: 'WELLNESS_EXAMS', value: 'Wellness Exams',
      aliases: ['annual checkup', 'preventive health'] }
  ],
  psychiatry: [
    { key: 'MENTAL_HEALTH_APPS', value: 'Mental Health Apps',
      aliases: ['mhealth', 'wellness app'] },
    { key: 'PSYCHOTHERAPY', value: 'Psychotherapy',
      aliases: ['talk therapy', 'counseling', 'psychotherapy', 'Mental Health Counseling'] },
    { key: 'ADDICTION_TREATMENT', value: 'Addiction Treatment',
      aliases: ['substance abuse', 'rehab'] },
    { key: 'Neurodiversity', value: 'Neurodiversity',
      aliases: ['neurodiversity', 'neurodivergent', 'neurodivergent care'] }
  ],
  public_health: [
    { key: 'COMMUNITY_HEALTH_PROGRAMS', value: 'Community Health Programs',
      aliases: ['health outreach', 'public health services'] },
    { key: 'EPIDEMIOLOGY', value: 'Epidemiology',
      aliases: ['disease study', 'public health research'] }
  ],
  radiology: [
    { key: 'MRI_IMAGING', value: 'MRI Imaging',
      aliases: ['magnetic resonance imaging', 'MRI scan'] },
    { key: 'CT_SCAN_SERVICES', value: 'CT Scan Services',
      aliases: ['computed tomography', 'CT imaging'] }
  ],
  reproductive_health: [
    { key: 'FERTILITY_TREATMENTS', value: 'Fertility Treatments',
      aliases: ['IVF', 'fertility care', 'sperm'] },
    { key: 'PREGNANCY_CARE', value: 'Pregnancy Care',
      aliases: ['prenatal care', 'maternal health'] },
    { key: 'SEXUAL_HEALTH_SERVICES', value: 'Sexual Health Services',
      aliases: ['STI testing', 'sexual wellness'] },
    { key: 'BIRTH_CONTROL_SERVICES', value: 'Birth Control Services',
      aliases: ['contraception', 'family planning'] },
    { key: 'BIRTH_SERVICES', value: 'Birth Services',
      aliases: ['labor and delivery', 'childbirth services'] },
  ],
  research: [
    { key: 'BIOTECHNOLOGY', value: 'Biotechnology', aliases: ['biotech research', 'bio-research'] },
    { key: 'PHARMACOLOGY_RESEARCH', value: 'Pharmacology Research',
      aliases: ['drug research', 'medication research'] },
    { key: 'CANCER_RESEARCH', value: 'Cancer Research',
      aliases: ['oncology research', 'tumor research'] },
    { key: 'GENOMIC_RESEARCH', value: 'Genomic Research',
      aliases: ['genetic research', 'DNA study'] }
  ],
  sleep_health: [
    { key: 'INSOMNIA_TREATMENT', value: 'Insomnia Treatment',
      aliases: ['sleep disorder care', 'sleep therapy'] },
    { key: 'SLEEP_APNEA_TREATMENT', value: 'Sleep Apnea Treatment',
      aliases: ['sleep disorder care', 'sleep therapy'] }
  ],
  speech_therapy: [
    { key: 'VOICE_REHABILITATION', value: 'Voice Rehabilitation',
      aliases: ['voice therapy', 'speech recovery'] },
    { key: 'LANGUAGE_DEVELOPMENT', value: 'Language Development',
      aliases: ['language skills', 'communication skills'] }
  ],
  surgery: [
    { key: 'MINIMALLY_INVASIVE_SURGERY', value: 'Minimally Invasive Surgery',
      aliases: ['laparoscopic surgery', 'keyhole surgery'] },
    { key: 'PLASTIC_SURGERY', value: 'Plastic Surgery',
      aliases: ['cosmetic surgery', 'reconstructive surgery'] }
  ],
  womens_health: [
    { key: 'MATERNAL_HEALTH', value: 'Maternal Health',
      aliases: ['pregnancy care', 'prenatal care'] }
  ]
}

seeded_count = 0
existing_count = 0
updated_count = 0

specialties.each do |domain_key, domain_specialties|
  domain = domains[domain_key]

  if domain.nil?
    puts "Skipping specialties for missing domain: #{domain_key}"
    next
  end

  domain_specialties.each do |specialty|
    specialty_record = CompanySpecialty.find_or_initialize_by(key: specialty[:key])

    if specialty_record.persisted?
      existing_count += 1
      updates_made = false

      if specialty_record.value != specialty[:value]
        specialty_record.value = specialty[:value]
        updates_made = true
        puts "Updated value for specialty #{specialty[:key]} in domain #{domain_key}."
      end

      if specialty_record.aliases != specialty[:aliases]
        specialty_record.aliases = specialty[:aliases]
        updates_made = true
        puts "Updated aliases for specialty #{specialty[:key]} in domain #{domain_key}."
      end

      if updates_made
        specialty_record.save!
        updated_count += 1
        puts "Specialty #{specialty[:key]} updated in database."
      else
        puts "Specialty #{specialty[:key]} already up-to-date."
      end
    else
      specialty_record.value = specialty[:value]
      specialty_record.aliases = specialty[:aliases]
      specialty_record.save!
      seeded_count += 1
      puts "Seeded new specialty: #{specialty[:key]} - #{specialty[:value]} with aliases: #{specialty[:aliases]}"
    end
  rescue StandardError => e
    puts "Error seeding specialty #{specialty[:key]} for domain #{domain_key}: #{e.message}"
  end
end

total_specialties_after = CompanySpecialty.count
puts "************** Seeded #{seeded_count} new specialties. #{existing_count} specialties already existed. #{updated_count} specialties updated. Total specialties in the table: #{total_specialties_after}."
