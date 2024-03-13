COMPANY_TYPES = {
  PHARMA: {
    VIRTUAL_PHARMACY: 'Virtual Pharmacy',
    DIGITAL_THERAPEUTICS: 'Digital Therapeutics',
    CHRONIC_DISEASE_MGMT: 'Chronic Disease Management',
    PERSONALIZED_PHARMACY_SERVICES: 'Personalized Pharmacy Services',
    PHARMACOGENOMICS: 'Pharmacogenomics',
    VITAMINS_SUPPLEMENTS: 'Vitamins & Supplements',
    HOME_LAB_TESTING_MONITORING: 'Home Lab Testing & Monitoring',
    HOSPITAL_PHARMACY: 'Hospital Pharmacy',
    NOVEL_PHARMA: 'Novel Pharma',
    DTC_PHARMACY_SERVICES: 'DTC Pharmacy Services',
    PHARM_SERVICES_WORKFLOW_EXPANSION: 'Pharm Services Workflow Expansion',
    PHARMACY_MEDIA: 'Pharmacy Media',
    CLINICAL_TRIALS: 'Clinical Trials'
  },
  DIGITAL_HEALTH: {
    MENTAL_HEALTH: 'Mental Health',
    GENETICS: 'Genetics',
    PROVIDER_DIRECTORIES_AND_CARE_NAVIGATION: 'Provider Directories & Care Navigation',
    HYBRID_VIRTUAL_INPERSON_CARE: 'Hybrid Virtual In-Person Care',
    DIGITAL_THERAPEUTICS: 'Digital Therapeutics',
    BILLING_AND_PAYMENTS: 'Billing & Payments',
    APP_DEPLOYMENT: 'App Deployment',
    SCREENING_MONITORING_DIAGNOSTICS: 'Screening, Monitoring, Diagnostics',
    DATA_INTEGRATION_ANALYTICS: 'Interoperability, Data, and Analytics',
    CLINICAL_INTELLIGENCE: 'Clinical Intelligence',
    HOME_HEALTH_TECH: 'Home Health Tech',
    VIRTUAL_CARE: 'Virtual Care',
    PATIENT_ENGAGEMENT: 'Digital Front Door & Patient Engagement',
    CARE_COORDINATION_COLLABORATION: 'Care Coordination & Collaboration',
    WORKFLOW_DIGITIZATION_AND_AUTOMATION: 'Workflow Digitization & Automation',
    COMPUTER_AIDED_IMAGING: 'Computer-Aided Imaging',
    RESEARCH: 'Biotechnology & Research',
    MEDIA: 'Media'
  },
  OTHER: {
    HEALTH_INSURANCE: 'Health Insurance',
    MEDICAL_DEVICES: 'Medical Devices',
    HEALTHCARE_CONSULTING: 'Healthcare Consulting',
    HEALTH_TECH_STARTUP_INCUBATOR: 'Health Tech Startup Incubator',
    HEALTH_NONPROFIT: 'Health Nonprofit',
    HEALTH_RESEARCH_INSTITUTE: 'Health Research Institute',
    HEALTH_POLICY_ADVOCACY: 'Health Policy Advocacy',
    HEALTH_MEDIA: 'Health Media'
  }
}



module CompanyTypesEnum
  extend ActiveSupport::Concern

  included do
    # enum company_type: {
    #   DENTAL: "Dental",
    #   MEDICAL: "Medical",
    #   OTHER: "Other"
    # }
    
    # validates :company_type, inclusion: { in: Company.company_types.keys }
  end
end