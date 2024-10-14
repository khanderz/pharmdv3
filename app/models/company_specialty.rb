class CompanySpecialty < ApplicationRecord
  belongs_to :healthcare_domain

  has_many :company_specializations
  has_many :companies, through: :company_specializations

  validates :key, :value, presence: true
  validates :key, uniqueness: { scope: :healthcare_domain_id }
end
