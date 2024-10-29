class UserHealthcareDomain < ApplicationRecord
  belongs_to :user
  belongs_to :healthcare_domain
end
