class Company < ApplicationRecord
  belongs_to :ats_type
  belongs_to :company_size, optional: true
  belongs_to :funding_type, optional: true
  belongs_to :city
  belongs_to :state, optional: true
  belongs_to :country
  belongs_to :healthcare_domain, foreign_key: 'healthcare_domain_id', class_name: 'CompanySpecialty'

  has_and_belongs_to_many :company_specialties, join_table: 'company_specializations'

  validates :company_name, presence: true, uniqueness: true
  validates :linkedin_url, uniqueness: true, allow_blank: true
end
