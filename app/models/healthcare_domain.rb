
class HealthcareDomain < ApplicationRecord
    has_many :company_specialties
    has_many :companies, foreign_key: 'healthcare_domain_id'
  
    validates :key, :value, presence: true, uniqueness: true
end
