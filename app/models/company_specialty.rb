# app/models/company_specialty.rb
class CompanySpecialty < ApplicationRecord
  belongs_to :company_type
  has_many :company_specializations
  has_many :companies, through: :company_specializations
end
