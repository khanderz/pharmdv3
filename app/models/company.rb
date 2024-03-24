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
      OTHERATS: 'OtherAts',
      EIGHTFOLD: 'EightFold'
    }

    validates :company_ats_type, inclusion: { in: Company.company_ats_types.keys }, allow_blank: true
    validate :validate_company_ats_type

    def validate_company_ats_type
      return if company_ats_type.blank?

      ats_keys = Company.company_ats_types.keys
      # puts "ats_keys: #{company_ats_type}"

      errors.add(:company_ats_type, :inclusion, message: "is not included in the list") unless ats_keys.include?(company_ats_type)
    end

    # # last funding type enum
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
    validate :validate_last_funding_type

    def validate_last_funding_type
      return if last_funding_type.blank?

      # puts "last_funding_type: #{last_funding_type}"

      funding_keys = Company.last_funding_types.keys
      # puts "funding_keys: #{last_funding_type}"

      errors.add(:last_funding_type, :inclusion, message: "is not included in the list") unless funding_keys.include?(last_funding_type)
    end

    #  company_type
    validate :valid_company_type
    validate :valid_company_type_value
  
    COMPANY_TYPES = ["PHARMA", "DIGITAL_HEALTH", "OTHER"]
  
    COMPANY_TYPE_VALUES = {
      "PHARMA" => [
        "VIRTUAL_PHARMACY", "DIGITAL_THERAPEUTICS", "CHRONIC_DISEASE_MGMT",
        "PERSONALIZED_PHARMACY_SERVICES", "PHARMACOGENOMICS", "VITAMINS_SUPPLEMENTS",
        "HOME_LAB_TESTING_MONITORING", "HOSPITAL_PHARMACY", "NOVEL_PHARMA",
        "DTC_PHARMACY_SERVICES", "PHARM_SERVICES_WORKFLOW_EXPANSION", "PHARMACY_MEDIA",
        "CLINICAL_TRIALS"
      ],
      "DIGITAL_HEALTH" => [
        "MENTAL_HEALTH", "GENETICS", "PROVIDER_DIRECTORIES_AND_CARE_NAVIGATION",
        "HYBRID_VIRTUAL_INPERSON_CARE", "DIGITAL_THERAPEUTICS", "BILLING_AND_PAYMENTS",
        "APP_DEPLOYMENT", "SCREENING_MONITORING_DIAGNOSTICS", "DATA_INTEGRATION_ANALYTICS",
        "CLINICAL_INTELLIGENCE", "HOME_HEALTH_TECH", "VIRTUAL_CARE",
        "PATIENT_ENGAGEMENT", "CARE_COORDINATION_COLLABORATION",
        "WORKFLOW_DIGITIZATION_AND_AUTOMATION", "COMPUTER_AIDED_IMAGING", "RESEARCH",
        "MEDIA", "REVENUE_CYCLE_MANAGEMENT"
      ],
      "OTHER" => [
        "HEALTH_INSURANCE", "MEDICAL_DEVICES", "HEALTHCARE_CONSULTING",
        "HEALTH_TECH_STARTUP_INCUBATOR", "HEALTH_NONPROFIT", "HEALTH_RESEARCH_INSTITUTE",
        "HEALTH_POLICY_ADVOCACY", "HEALTH_MEDIA"
      ]
    }
  
    def valid_company_type
      return if company_type.blank?
  
      unless COMPANY_TYPES.include?(company_type)
        errors.add(:company_type, "is not a valid company type")
      end
    end
  
    def valid_company_type_value
      return if company_type.blank? || company_type_value.blank?
  
      unless COMPANY_TYPE_VALUES[company_type].include?(company_type_value)
        errors.add(:company_type_value, "is not a valid value for company type #{company_type}")
      end
    end

    has_many :job_posts, dependent: :destroy 
end
