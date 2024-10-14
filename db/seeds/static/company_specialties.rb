# Fetch the HealthcareDomain records to associate with the CompanySpecialties
behavioral_health_domain = HealthcareDomain.find_by(key: 'BEHAVIORAL_HEALTH')
cardiology_domain = HealthcareDomain.find_by(key: 'CARDIOLOGY')
critical_care_domain = HealthcareDomain.find_by(key: 'CRITICAL_CARE')
dental_domain = HealthcareDomain.find_by(key: 'DENTAL')
dermatology_domain = HealthcareDomain.find_by(key: 'DERMATOLOGY')
digital_health_domain = HealthcareDomain.find_by(key: 'DIGITAL_HEALTH')
geriatrics_domain = HealthcareDomain.find_by(key: 'GERIATRICS')
neurology_domain = HealthcareDomain.find_by(key: 'NEUROLOGY')
nursing_domain = HealthcareDomain.find_by(key: 'NURSING')
obstetrics_domain = HealthcareDomain.find_by(key: 'OBSTETRICS')
oncology_domain = HealthcareDomain.find_by(key: 'ONCOLOGY')
optometry_domain = HealthcareDomain.find_by(key: 'OPTOMETRY')
pathology_domain = HealthcareDomain.find_by(key: 'PATHOLOGY')
pediatrics_domain = HealthcareDomain.find_by(key: 'PEDIATRICS')
pharma_domain = HealthcareDomain.find_by(key: 'PHARMA')
physical_therapy_domain = HealthcareDomain.find_by(key: 'PHYSICAL_THERAPY')
podiatry_domain = HealthcareDomain.find_by(key: 'PODIATRY')
primary_care_domain = HealthcareDomain.find_by(key: 'PRIMARY_CARE')
psychiatry_domain = HealthcareDomain.find_by(key: 'PSYCHIATRY')
public_health_domain = HealthcareDomain.find_by(key: 'PUBLIC_HEALTH')
radiology_domain = HealthcareDomain.find_by(key: 'RADIOLOGY')
rehabilitation_domain = HealthcareDomain.find_by(key: 'REHABILITATION')
respiratory_domain = HealthcareDomain.find_by(key: 'RESPIRATORY')
speech_therapy_domain = HealthcareDomain.find_by(key: 'SPEECH_THERAPY')
surgery_domain = HealthcareDomain.find_by(key: 'SURGERY')


# Pharma specialties
pharma_specialties = [
  { key: 'CHRONIC_DISEASE_MGMT', value: 'Chronic Disease Management', healthcare_domain_id: pharma_domain.id },
  { key: 'CLINICAL_TRIALS', value: 'Clinical Trials', healthcare_domain_id: pharma_domain.id },
  { key: 'DIGITAL_THERAPEUTICS', value: 'Digital Therapeutics', healthcare_domain_id: pharma_domain.id },
  { key: 'DTC_PHARMACY_SERVICES', value: 'DTC Pharmacy Services', healthcare_domain_id: pharma_domain.id },
  { key: 'HOME_LAB_TESTING_MONITORING', value: 'Home Lab Testing & Monitoring', healthcare_domain_id: pharma_domain.id },
  { key: 'HOSPITAL_PHARMACY', value: 'Hospital Pharmacy', healthcare_domain_id: pharma_domain.id },
  { key: 'NOVEL_PHARMA', value: 'Novel Pharma', healthcare_domain_id: pharma_domain.id },
  { key: 'PERSONALIZED_PHARMACY_SERVICES', value: 'Personalized Pharmacy Services', healthcare_domain_id: pharma_domain.id },
  { key: 'PHARM_SERVICES_WORKFLOW_EXPANSION', value: 'Pharm Services Workflow Expansion', healthcare_domain_id: pharma_domain.id },
  { key: 'PHARMACOGENOMICS', value: 'Pharmacogenomics', healthcare_domain_id: pharma_domain.id },
  { key: 'PHARMACY_MEDIA', value: 'Pharmacy Media', healthcare_domain_id: pharma_domain.id },
  { key: 'VIRTUAL_PHARMACY', value: 'Virtual Pharmacy', healthcare_domain_id: pharma_domain.id },
  { key: 'VITAMINS_SUPPLEMENTS', value: 'Vitamins & Supplements', healthcare_domain_id: pharma_domain.id }
]

# Digital Health specialties
digital_health_specialties = [
  { key: 'APP_DEPLOYMENT', value: 'App Deployment', healthcare_domain_id: digital_health_domain.id },
  { key: 'BILLING_AND_PAYMENTS', value: 'Billing & Payments', healthcare_domain_id: digital_health_domain.id },
  { key: 'BIOTECHNOLOGY_RESEARCH', value: 'Biotechnology & Research', healthcare_domain_id: digital_health_domain.id },
  { key: 'CARE_COORDINATION_COLLABORATION', value: 'Care Coordination & Collaboration', healthcare_domain_id: digital_health_domain.id },
  { key: 'CLINICAL_INTELLIGENCE', value: 'Clinical Intelligence', healthcare_domain_id: digital_health_domain.id },
  { key: 'COMPUTER_AIDED_IMAGING', value: 'Computer-Aided Imaging', healthcare_domain_id: digital_health_domain.id },
  { key: 'DATA_INTEGRATION_ANALYTICS', value: 'Data Integration & Analytics', healthcare_domain_id: digital_health_domain.id },
  { key: 'DIGITAL_THERAPEUTICS', value: 'Digital Therapeutics', healthcare_domain_id: digital_health_domain.id },
  { key: 'GENETICS', value: 'Genetics', healthcare_domain_id: digital_health_domain.id },
  { key: 'HOME_HEALTH_TECH', value: 'Home Health Tech', healthcare_domain_id: digital_health_domain.id },
  { key: 'HYBRID_VIRTUAL_INPERSON_CARE', value: 'Hybrid Virtual In-Person Care', healthcare_domain_id: digital_health_domain.id },
  { key: 'MEDIA', value: 'Media', healthcare_domain_id: digital_health_domain.id },
  { key: 'MENTAL_HEALTH', value: 'Mental Health', healthcare_domain_id: digital_health_domain.id },
  { key: 'PATIENT_ENGAGEMENT', value: 'Patient Engagement', healthcare_domain_id: digital_health_domain.id },
  { key: 'PROVIDER_DIRECTORIES_AND_CARE_NAVIGATION', value: 'Provider Directories & Care Navigation', healthcare_domain_id: digital_health_domain.id },
  { key: 'REVENUE_CYCLE_MGMT', value: 'Revenue Cycle Management', healthcare_domain_id: digital_health_domain.id },
  { key: 'SCREENING_MONITORING_DIAGNOSTICS', value: 'Screening, Monitoring, Diagnostics', healthcare_domain_id: digital_health_domain.id },
  { key: 'VIRTUAL_CARE', value: 'Virtual Care', healthcare_domain_id: digital_health_domain.id },
  { key: 'WORKFLOW_DIGITIZATION_AND_AUTOMATION', value: 'Workflow Digitization & Automation', healthcare_domain_id: digital_health_domain.id }
]

# Dental specialties
dental_specialties = [
  { key: 'DENTAL_IMPLANTS', value: 'Dental Implants', healthcare_domain_id: dental_domain.id },
  { key: 'ORTHODONTICS', value: 'Orthodontics', healthcare_domain_id: dental_domain.id },
  { key: 'PEDIATRIC_DENTISTRY', value: 'Pediatric Dentistry', healthcare_domain_id: dental_domain.id }
]

# Nursing specialties
nursing_specialties = [
  { key: 'GERIATRIC_NURSING', value: 'Geriatric Nursing', healthcare_domain_id: nursing_domain.id },
  { key: 'HOME_HEALTHCARE', value: 'Home Healthcare', healthcare_domain_id: nursing_domain.id },
  { key: 'PEDIATRIC_NURSING', value: 'Pediatric Nursing', healthcare_domain_id: nursing_domain.id }
]

# Cardiology specialties
cardiology_specialties = [
  { key: 'CARDIAC_REHABILITATION', value: 'Cardiac Rehabilitation', healthcare_domain_id: cardiology_domain.id },
  { key: 'HEART_SURGERY', value: 'Heart Surgery', healthcare_domain_id: cardiology_domain.id }
]

# Add more domains and specialties for other healthcare areas
specialties = pharma_specialties + digital_health_specialties + dental_specialties + nursing_specialties + cardiology_specialties
# You can extend this list for other domains such as optometry, oncology, pediatrics, etc.

specialties.each do |specialty|
  begin
    CompanySpecialty.find_or_create_by!(key: specialty[:key], healthcare_domain_id: specialty[:healthcare_domain_id]) do |s|
      s.value = specialty[:value]
    end
  rescue StandardError => e
    puts "Error seeding specialty: #{specialty[:key]} - #{e.message}"
  end
end

puts "**************Seeded specialties for all healthcare domains."