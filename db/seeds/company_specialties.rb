# Fetch the CompanyType records to associate with the CompanySpecialties
pharma_type = CompanyType.find_by(key: 'PHARMA')
digital_health_type = CompanyType.find_by(key: 'DIGITAL_HEALTH')
other_type = CompanyType.find_by(key: 'OTHER')

# Pharma specialties
pharma_specialties = [
  { key: 'CHRONIC_DISEASE_MGMT', value: 'Chronic Disease Management', company_type_id: pharma_type.id },
  { key: 'CLINICAL_TRIALS', value: 'Clinical Trials', company_type_id: pharma_type.id },
  { key: 'DIGITAL_THERAPEUTICS', value: 'Digital Therapeutics', company_type_id: pharma_type.id },
  { key: 'DTC_PHARMACY_SERVICES', value: 'DTC Pharmacy Services', company_type_id: pharma_type.id },
  { key: 'HOME_LAB_TESTING_MONITORING', value: 'Home Lab Testing & Monitoring', company_type_id: pharma_type.id },
  { key: 'HOSPITAL_PHARMACY', value: 'Hospital Pharmacy', company_type_id: pharma_type.id },
  { key: 'NOVEL_PHARMA', value: 'Novel Pharma', company_type_id: pharma_type.id },
  { key: 'PERSONALIZED_PHARMACY_SERVICES', value: 'Personalized Pharmacy Services', company_type_id: pharma_type.id },
  { key: 'PHARM_SERVICES_WORKFLOW_EXPANSION', value: 'Pharm Services Workflow Expansion', company_type_id: pharma_type.id },
  { key: 'PHARMACOGENOMICS', value: 'Pharmacogenomics', company_type_id: pharma_type.id },
  { key: 'PHARMACY_MEDIA', value: 'Pharmacy Media', company_type_id: pharma_type.id },
  { key: 'VIRTUAL_PHARMACY', value: 'Virtual Pharmacy', company_type_id: pharma_type.id },
  { key: 'VITAMINS_SUPPLEMENTS', value: 'Vitamins & Supplements', company_type_id: pharma_type.id }
]

pharma_specialties.each do |specialty|
  CompanySpecialty.find_or_create_by(key: specialty[:key], company_type_id: specialty[:company_type_id]) do |s|
    s.value = specialty[:value]
  end
  puts "Seeded Pharma Specialty: #{specialty[:key]} - #{specialty[:value]}"
end

# Digital Health specialties
digital_health_specialties = [
  { key: 'APP_DEPLOYMENT', value: 'App Deployment', company_type_id: digital_health_type.id },
  { key: 'BILLING_AND_PAYMENTS', value: 'Billing & Payments', company_type_id: digital_health_type.id },
  { key: 'RESEARCH', value: 'Biotechnology & Research', company_type_id: digital_health_type.id },
  { key: 'CARE_COORDINATION_COLLABORATION', value: 'Care Coordination & Collaboration', company_type_id: digital_health_type.id },
  { key: 'CLINICAL_INTELLIGENCE', value: 'Clinical Intelligence', company_type_id: digital_health_type.id },
  { key: 'COMPUTER_AIDED_IMAGING', value: 'Computer-Aided Imaging', company_type_id: digital_health_type.id },
  { key: 'DATA_INTEGRATION_ANALYTICS', value: 'Data Integration & Analytics', company_type_id: digital_health_type.id },
  { key: 'DIGITAL_THERAPEUTICS', value: 'Digital Therapeutics', company_type_id: digital_health_type.id },
  { key: 'GENETICS', value: 'Genetics', company_type_id: digital_health_type.id },
  { key: 'HOME_HEALTH_TECH', value: 'Home Health Tech', company_type_id: digital_health_type.id },
  { key: 'HYBRID_VIRTUAL_INPERSON_CARE', value: 'Hybrid Virtual In-Person Care', company_type_id: digital_health_type.id },
  { key: 'MEDIA', value: 'Media', company_type_id: digital_health_type.id },
  { key: 'MENTAL_HEALTH', value: 'Mental Health', company_type_id: digital_health_type.id },
  { key: 'PATIENT_ENGAGEMENT', value: 'Patient Engagement', company_type_id: digital_health_type.id },
  { key: 'PROVIDER_DIRECTORIES_AND_CARE_NAVIGATION', value: 'Provider Directories & Care Navigation', company_type_id: digital_health_type.id },
  { key: 'SCREENING_MONITORING_DIAGNOSTICS', value: 'Screening, Monitoring, Diagnostics', company_type_id: digital_health_type.id },
  { key: 'VIRTUAL_CARE', value: 'Virtual Care', company_type_id: digital_health_type.id },
  { key: 'WORKFLOW_DIGITIZATION_AND_AUTOMATION', value: 'Workflow Digitization & Automation', company_type_id: digital_health_type.id },
  { key: 'REVENUE_CYCLE_MGMT', value: 'Revenue Cycle Management', company_type_id: digital_health_type.id }
]

digital_health_specialties.each do |specialty|
  CompanySpecialty.find_or_create_by(key: specialty[:key], company_type_id: specialty[:company_type_id]) do |s|
    s.value = specialty[:value]
  end
  puts "Seeded Digital Health Specialty: #{specialty[:key]} - #{specialty[:value]}"
end

# Other specialties
other_specialties = [
  { key: 'OTHER', value: 'Other', company_type_id: other_type.id }
]

other_specialties.each do |specialty|
  CompanySpecialty.find_or_create_by(key: specialty[:key], company_type_id: specialty[:company_type_id]) do |s|
    s.value = specialty[:value]
  end
  puts "Seeded Other Specialty: #{specialty[:key]} - #{specialty[:value]}"
end
