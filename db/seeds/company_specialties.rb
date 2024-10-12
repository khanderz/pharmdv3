#  pharma
pharma_specialties = CompanySpecialty.create([
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
])

pharma_specialties.each do |specialty|
  puts "Seeded Pharma Specialty: #{specialty.key} - #{specialty.value}"
end

#  digital health
digital_health_specialties = CompanySpecialty.create([
  { key: 'APP_DEPLOYMENT', value: 'App Deployment' },
  { key: 'BILLING_AND_PAYMENTS', value: 'Billing & Payments' },
  { key: 'RESEARCH', value: 'Biotechnology & Research' },
  { key: 'CARE_COORDINATION_COLLABORATION', value: 'Care Coordination & Collaboration' },
  { key: 'CLINICAL_INTELLIGENCE', value: 'Clinical Intelligence' },
  { key: 'COMPUTER_AIDED_IMAGING', value: 'Computer-Aided Imaging' },
  { key: 'DATA_INTEGRATION_ANALYTICS', value: 'Data Integration & Analytics' },
  { key: 'DIGITAL_THERAPEUTICS', value: 'Digital Therapeutics' },
  { key: 'GENETICS', value: 'Genetics' },
  { key: 'HOME_HEALTH_TECH', value: 'Home Health Tech' },
  { key: 'HYBRID_VIRTUAL_INPERSON_CARE', value: 'Hybrid Virtual In-Person Care' },
  { key: 'MEDIA', value: 'Media' },
  { key: 'MENTAL_HEALTH', value: 'Mental Health' },
  { key: 'PATIENT_ENGAGEMENT', value: 'Patient Engagement' },
  { key: 'PROVIDER_DIRECTORIES_AND_CARE_NAVIGATION', value: 'Provider Directories & Care Navigation' },
  { key: 'SCREENING_MONITORING_DIAGNOSTICS', value: 'Screening, Monitoring, Diagnostics' },
  { key: 'VIRTUAL_CARE', value: 'Virtual Care' },
  { key: 'WORKFLOW_DIGITIZATION_AND_AUTOMATION', value: 'Workflow Digitization & Automation' },
  { key: 'REVENUE_CYCLE_MGMT', value: 'Revenue Cycle Management' }
])

digital_health_specialties.each do |specialty|
  puts "Seeded Digital Health Specialty: #{specialty.key} - #{specialty.value}"
end

#  other
other_specialties = CompanySpecialty.create([
    { key: 'OTHER', value: 'Other' }
])

other_specialties.each do |specialty|
  puts "Seeded Other Specialty: #{specialty.key} - #{specialty.value}"
end
