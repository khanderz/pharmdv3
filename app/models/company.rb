class Company < ApplicationRecord

  # ATS type enum
  enum :company_ats_type, {    
      GREENHOUSE: 'Greenhouse',
      LEVER: 'Lever',
      BAMBOOHR: 'BambooHR',
      MYWORKDAY: 'MyWorkday',
      WELLFOUND: 'WellFound',
      LINKEDIN: 'LinkedIn',
      PROPRIETARY: 'Proprietary',
      OTHERATS: 'Other',
      EIGHTFOLD: 'EightFold'
    }

    validates :company_ats_type, inclusion: { in: Company.company_ats_types.keys }, allow_blank: true

    # last funding type enum
    enum :last_funding_type, {
      ANGEL: 'Angel',
      CONVERTIBLE_NOTE: 'Convertible Note',
      CORPORATE_ROUND: 'Corporate Round',
      DEBT_FINANCING: 'Debt Financing',
      EQUITY_CROWDFUNDING: 'Equity Crowdfunding',
      GRANT: 'Grant',
      INITIAL_COIN_OFFERING: 'Initial Coin Offering',
      NON_EQUITY_ASSISTANCE: 'Non-Equity Assistance',
      POST_IPO_DEBT: 'Post-IPO Debt',
      POST_IPO_EQUITY: 'Post-IPO Equity',
      POST_IPO_SECONDARY: 'Post-IPO Secondary',
      PRE_SEED: 'Pre-Seed',
      PRIVATE_EQUITY: 'Private Equity',
      PRODUCT_CROWDFUNDING: 'Product Crowdfunding',
      SECONDARY_MARKET: 'Secondary Market',
      SEED: 'Seed',
      SERIES_A: 'Series A',
      SERIES_B: 'Series B',
      SERIES_C: 'Series C',
      SERIES_D: 'Series D',
      SERIES_E: 'Series E',
      SERIES_F: 'Series F',
      SERIES_G: 'Series G',
      SERIES_H: 'Series H',
      SERIES_I: 'Series I',
      SERIES_J: 'Series J',
      SERIES_UNKNOWN_VENTURE: 'Venture - Series Unknown',
      UNDISCLOSED: 'Undisclosed',
      OTHERFUNDING: 'Other'
    }

    validates :last_funding_type, inclusion: { in: Company.last_funding_types.keys }, allow_blank: true


    #  company type
    enum company_type: {
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
        MEDIA: 'Media',
        REVENUE_CYCLE_MANAGEMENT: 'Revenue Cycle Management'
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

    # validates :company_type, inclusion: { in: Company.company_types.keys }, allow_blank: true

    # validates :company_type_value, inclusion: { in: Company.company_types.values.flatten }, allow_blank: true
    validate :validate_company_type

    def validate_company_type
      unless company_type.present? && Company.company_types.keys.include?(company_type.to_sym)
        errors.add(:company_type, 'is not valid')
      end
  
      if company_type.present? && Company.company_types[company_type.to_sym].present?
        unless company_type_value.present? && Company.company_types[company_type.to_sym].values.flatten.include?(company_type_value)
          errors.add(:company_type_value, 'is not valid')
        end
      end
    end

    has_many :job_posts, dependent: :destroy 
end
