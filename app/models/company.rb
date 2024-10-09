# app/models/company.rb
class Company < ApplicationRecord
    has_many :job_posts, foreign_key: :companies_id, dependent: :destroy

#  how to use enums --
#     Company::COMPANY_TYPES   # Access the company types enum
# Company::PHARMACY_TYPES  # Access the pharmacy types enum
# Company::DIGITAL_HEALTH_TYPES  # Access the digital health types enum


 # Enum for Company Types
 COMPANY_TYPES = {
  'PHARMA' => 'Pharmacy',
  'DIGITAL_HEALTH' => 'Digital Health',
  'OTHER' => 'Other'
}.freeze

# Enum for Pharmacy Types
PHARMACY_TYPES = {
  'CHRONIC_DISEASE_MGMT' => 'Chronic Disease Management',
  'CLINICAL_TRIALS' => 'Clinical Trials',
  'DIGITAL_THERAPEUTICS' => 'Digital Therapeutics',
  'DTC_PHARMACY_SERVICES' => 'DTC Pharmacy Services',
  'HOME_LAB_TESTING_MONITORING' => 'Home Lab Testing & Monitoring',
  'HOSPITAL_PHARMACY' => 'Hospital Pharmacy',
  'NOVEL_PHARMA' => 'Novel Pharma',
  'PERSONALIZED_PHARMACY_SERVICES' => 'Personalized Pharmacy Services',
  'PHARM_SERVICES_WORKFLOW_EXPANSION' => 'Pharm Services Workflow Expansion',
  'PHARMACOGENOMICS' => 'Pharmacogenomics',
  'PHARMACY_MEDIA' => 'Pharmacy Media',
  'VIRTUAL_PHARMACY' => 'Virtual Pharmacy',
  'VITAMINS_SUPPLEMENTS' => 'Vitamins & Supplements'
}.freeze

# Enum for Digital Health Types
DIGITAL_HEALTH_TYPES = {
  'APP_DEPLOYMENT' => 'App Deployment',
  'BILLING_AND_PAYMENTS' => 'Billing & Payments',
  'RESEARCH' => 'Biotechnology & Research',
  'CARE_COORDINATION_COLLABORATION' => 'Care Coordination & Collaboration',
  'CLINICAL_INTELLIGENCE' => 'Clinical Intelligence',
  'COMPUTER_AIDED_IMAGING' => 'Computer-Aided Imaging',
  'DATA_INTEGRATION_ANALYTICS' => 'Data Integration & Analytics',
  'DIGITAL_THERAPEUTICS' => 'Digital Therapeutics',
  'GENETICS' => 'Genetics',
  'HOME_HEALTH_TECH' => 'Home Health Tech',
  'HYBRID_VIRTUAL_INPERSON_CARE' => 'Hybrid Virtual In-Person Care',
  'MEDIA' => 'Media',
  'MENTAL_HEALTH' => 'Mental Health',
  'PATIENT_ENGAGEMENT' => 'Patient Engagement',
  'PROVIDER_DIRECTORIES_CARE_NAVIGATION' => 'Provider Directories & Care Navigation',
  'SCREENING_MONITORING_DIAGNOSTICS' => 'Screening, Monitoring, Diagnostics',
  'VIRTUAL_CARE' => 'Virtual Care',
  'WORKFLOW_DIGITIZATION_AUTOMATION' => 'Workflow Digitization & Automation',
  'REVENUE_CYCLE_MGMT' => 'Revenue Cycle Management'
}.freeze

# Add any necessary methods for accessing the human-readable formats
def self.human_readable_company_types
  COMPANY_TYPES
end

def self.human_readable_pharmacy_types
  PHARMACY_TYPES
end

def self.human_readable_digital_health_types
  DIGITAL_HEALTH_TYPES
end
  end
  