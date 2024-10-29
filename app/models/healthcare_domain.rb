
class HealthcareDomain < ApplicationRecord
    has_many :company_domains
    has_many :companies, through: :company_domains
  
    validates :key, :value, presence: true, uniqueness: true
  end
  