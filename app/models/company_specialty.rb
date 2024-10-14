class CompanySpecialty < ApplicationRecord
  belongs_to :healthcare_domain

  has_and_belongs_to_many :companies, join_table: 'company_specializations'

  validates :key, :value, presence: true
  validates :key, uniqueness: { scope: :healthcare_domain_id }
end
