export interface CompanySpecialty {
    key: PharmaSpecialtyKey | DigitalHealthSpecialtyKey;
    value: PharmaSpecialtyValue | DigitalHealthSpecialtyValue;
}

export const PharmaSpecialty = {
    CHRONIC_DISEASE_MGMT: 'Chronic Disease Management',
    CLINICAL_TRIALS: 'Clinical Trials',
    DIGITAL_THERAPEUTICS: 'Digital Therapeutics',
    DTC_PHARMACY_SERVICES: 'DTC Pharmacy Services',
    HOME_LAB_TESTING_MONITORING: 'Home Lab Testing & Monitoring',
    HOSPITAL_PHARMACY: 'Hospital Pharmacy',
    NOVEL_PHARMA: 'Novel Pharma',
    PERSONALIZED_PHARMACY_SERVICES: 'Personalized Pharmacy Services',
    PHARM_SERVICES_WORKFLOW_EXPANSION: 'Pharm Services Workflow Expansion',
    PHARMACOGENOMICS: 'Pharmacogenomics',
    PHARMACY_MEDIA: 'Pharmacy Media',
    VIRTUAL_PHARMACY: 'Virtual Pharmacy',
    VITAMINS_SUPPLEMENTS: 'Vitamins & Supplements',
} as const;

export type PharmaSpecialtyKey = keyof typeof PharmaSpecialty;
export type PharmaSpecialtyValue = typeof PharmaSpecialty[PharmaSpecialtyKey];

export const DigitalHealthSpecialty = {
    APP_DEPLOYMENT: 'App Deployment',
    BILLING_AND_PAYMENTS: 'Billing & Payments',
    CARE_COORDINATION_COLLABORATION: 'Care Coordination & Collaboration',
    CLINICAL_INTELLIGENCE: 'Clinical Intelligence',
    COMPUTER_AIDED_IMAGING: 'Computer-Aided Imaging',
    DATA_INTEGRATION_ANALYTICS: 'Data Integration & Analytics',
    DIGITAL_THERAPEUTICS: 'Digital Therapeutics',
    GENETICS: 'Genetics',
    HOME_HEALTH_TECH: 'Home Health Tech',
    HYBRID_VIRTUAL_INPERSON_CARE: 'Hybrid Virtual In-Person Care',
    MEDIA: 'Media',
    PATIENT_ENGAGEMENT: 'Patient Engagement',
    PROVIDER_DIRECTORIES_AND_CARE_NAVIGATION: 'Provider Directories & Care Navigation',
    REVENUE_CYCLE_MGMT: 'Revenue Cycle Management',
    SCREENING_MONITORING_DIAGNOSTICS: 'Screening, Monitoring, Diagnostics',
    VIRTUAL_CARE: 'Virtual Care',
    WORKFLOW_DIGITIZATION_AND_AUTOMATION: 'Workflow Digitization & Automation',
} as const;

export type DigitalHealthSpecialtyKey = keyof typeof DigitalHealthSpecialty;
export type DigitalHealthSpecialtyValue = typeof DigitalHealthSpecialty[DigitalHealthSpecialtyKey];
