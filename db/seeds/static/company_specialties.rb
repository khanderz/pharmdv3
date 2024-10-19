# Fetch the HealthcareDomain records to associate with the CompanySpecialties
domains = {
  behavioral_health: HealthcareDomain.find_by(key: 'BEHAVIORAL_HEALTH'),
  cardiology: HealthcareDomain.find_by(key: 'CARDIOLOGY'),
  dental: HealthcareDomain.find_by(key: 'DENTAL'),
  dermatology: HealthcareDomain.find_by(key: 'DERMATOLOGY'),
  digital_health: HealthcareDomain.find_by(key: 'DIGITAL_HEALTH'),
  geriatrics: HealthcareDomain.find_by(key: 'GERIATRICS'),
  neurology: HealthcareDomain.find_by(key: 'NEUROLOGY'),
  nursing: HealthcareDomain.find_by(key: 'NURSING'),
  obstetrics: HealthcareDomain.find_by(key: 'OBSTETRICS'),
  oncology: HealthcareDomain.find_by(key: 'ONCOLOGY'),
  optometry: HealthcareDomain.find_by(key: 'OPTOMETRY'),
  pathology: HealthcareDomain.find_by(key: 'PATHOLOGY'),
  pediatrics: HealthcareDomain.find_by(key: 'PEDIATRICS'),
  pharma: HealthcareDomain.find_by(key: 'PHARMA'),
  physical_therapy: HealthcareDomain.find_by(key: 'PHYSICAL_THERAPY'),
  podiatry: HealthcareDomain.find_by(key: 'PODIATRY'),
  primary_care: HealthcareDomain.find_by(key: 'PRIMARY_CARE'),
  psychiatry: HealthcareDomain.find_by(key: 'PSYCHIATRY'),
  public_health: HealthcareDomain.find_by(key: 'PUBLIC_HEALTH'),
  radiology: HealthcareDomain.find_by(key: 'RADIOLOGY'),
  research: HealthcareDomain.find_by(key: 'RESEARCH'),
  rehabilitation: HealthcareDomain.find_by(key: 'REHABILITATION'),
  respiratory: HealthcareDomain.find_by(key: 'RESPIRATORY'),
  speech_therapy: HealthcareDomain.find_by(key: 'SPEECH_THERAPY'),
  surgery: HealthcareDomain.find_by(key: 'SURGERY')
}

# Log missing domains for better feedback during seeding
missing_domains = domains.select { |key, domain| domain.nil? }
if missing_domains.any?
  missing_domains.each { |key, _| puts "Warning: Healthcare domain '#{key}' not found in database." }
end

# Define the specialties for different healthcare domains
specialties = {
  pharma: [
    { key: 'CHRONIC_DISEASE_MGMT', value: 'Chronic Disease Management' },
    { key: 'CLINICAL_TRIALS', value: 'Clinical Trials' },
    { key: 'DIGITAL_THERAPEUTICS', value: 'Digital Therapeutics' },
    { key: 'DTC_PHARMACY_SERVICES', value: 'DTC Pharmacy Services' },
    { key: 'HOME_LAB_TESTING_MONITORING', value: 'Home Lab Testing & Monitoring' },
    { key: 'HOSPITAL_PHARMACY', value: 'Hospital Pharmacy' },
    { key: 'NOVEL_PHARMA', value: 'Novel Pharma' },
    { key: 'PERSONALIZED_PHARMACY_SERVICES', value: 'Personalized Pharmacy Services' },
    { key: 'PHARM_SERVICES_WORKFLOW_EXPANSION', value: 'Pharm Services Workflow Expansion' },
    { key: 'PHARMACOGENOMICS', value: 'Pharmacogenomics' },
    { key: 'PHARMACY_MEDIA', value: 'Pharmacy Media' },
    { key: 'VIRTUAL_PHARMACY', value: 'Virtual Pharmacy' },
    { key: 'VITAMINS_SUPPLEMENTS', value: 'Vitamins & Supplements' }
  ],
  digital_health: [
    { key: 'APP_DEPLOYMENT', value: 'App Deployment' },
    { key: 'BILLING_AND_PAYMENTS', value: 'Billing & Payments' },
    { key: 'CARE_COORDINATION_COLLABORATION', value: 'Care Coordination & Collaboration' },
    { key: 'CLINICAL_INTELLIGENCE', value: 'Clinical Intelligence' },
    { key: 'COMPUTER_AIDED_IMAGING', value: 'Computer-Aided Imaging' },
    { key: 'DATA_INTEGRATION_ANALYTICS', value: 'Data Integration & Analytics' },
    { key: 'DIGITAL_THERAPEUTICS', value: 'Digital Therapeutics' },
    { key: 'GENETICS', value: 'Genetics' },
    { key: 'HOME_HEALTH_TECH', value: 'Home Health Tech' },
    { key: 'HYBRID_VIRTUAL_INPERSON_CARE', value: 'Hybrid Virtual In-Person Care' },
    { key: 'MEDIA', value: 'Media' },
    { key: 'PATIENT_ENGAGEMENT', value: 'Patient Engagement' },
    { key: 'PROVIDER_DIRECTORIES_AND_CARE_NAVIGATION', value: 'Provider Directories & Care Navigation' },
    { key: 'REVENUE_CYCLE_MGMT', value: 'Revenue Cycle Management' },
    { key: 'SCREENING_MONITORING_DIAGNOSTICS', value: 'Screening, Monitoring, Diagnostics' },
    { key: 'VIRTUAL_CARE', value: 'Virtual Care' },
    { key: 'WORKFLOW_DIGITIZATION_AND_AUTOMATION', value: 'Workflow Digitization & Automation' }
  ],
  dental: [
    { key: 'DENTAL_IMPLANTS', value: 'Dental Implants' },
    { key: 'ORTHODONTICS', value: 'Orthodontics' },
    { key: 'PEDIATRIC_DENTISTRY', value: 'Pediatric Dentistry' }
  ],
  nursing: [
    { key: 'GERIATRIC_NURSING', value: 'Geriatric Nursing' },
    { key: 'HOME_HEALTHCARE', value: 'Home Healthcare' },
    { key: 'PEDIATRIC_NURSING', value: 'Pediatric Nursing' }
  ],
  cardiology: [
    { key: 'CARDIAC_REHABILITATION', value: 'Cardiac Rehabilitation' },
    { key: 'HEART_SURGERY', value: 'Heart Surgery' }
  ],
  research: [
    { key: 'BIOTECHNOLOGY', value: 'Biotechnology' },
  ]
}

seeded_count = 0
total_specialties = CompanySpecialty.count

specialties.each do |domain_key, domain_specialties|
  domain = domains[domain_key]

  if domain.nil?
    puts "Skipping specialties for missing domain: #{domain_key}"
    next
  end

  domain_specialties.each do |specialty|
    specialty_record = CompanySpecialty.find_or_initialize_by(
      key: specialty[:key]
    )

    unless specialty_record.persisted?
      specialty_record.update(value: specialty[:value])
      seeded_count += 1
      puts "Seeded specialty: #{specialty[:value]} for domain: #{domain_key}"
    end
  end
end

total_specialties_after = CompanySpecialty.count

puts "************** Seeded #{seeded_count} specialties. Total specialties in the table: #{total_specialties_after}."
