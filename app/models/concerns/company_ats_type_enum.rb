# frozen_string_literal: true

# module company_ats_type_enum
#   extend ActiveSupport::Concern

#   included do
#     enum company_ats_type: {
#       GREENHOUSE: 'Greenhouse',
#       LEVER: 'Lever',
#       BAMBOOHR: 'BambooHR',
#       MYWORKDAY: 'MyWorkday',
#       WELLFOUND: 'WellFound',
#       LINKEDIN: 'LinkedIn',
#       PROPRIETARY: 'Proprietary',
#       OTHER: 'Other',
#       EIGHTFOLD: 'EightFold'
#     }

#     # plural ? atsEnums
#     validates :company_ats_type, inclusion: { in: Company.company_ats_types.keys }
#   end
# end
