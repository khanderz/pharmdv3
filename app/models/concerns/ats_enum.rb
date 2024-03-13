module AtsEnum
  extend ActiveSupport::Concern

  included do
    enum atsEnum: {    
      GREENHOUSE: 'Greenhouse',
      LEVER: 'Lever',
      BAMBOOHR: 'BambooHR',
      MYWORKDAY: 'MyWorkday',
      WELLFOUND: 'WellFound',
      LINKEDIN: 'LinkedIn',
      PROPRIETARY: 'Proprietary',
      OTHER: 'Other',
      EIGHTFOLD: 'EightFold'
    }

    # plural ? atsEnums
    validates :company_ats_type, inclusion: { in: Company.atsEnums.keys }
  end
end