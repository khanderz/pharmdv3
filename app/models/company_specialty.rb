# app/models/company_specialty.rb
class CompanySpecialty < ApplicationRecord
  has_many :company_specialties_companies
  has_many :companies, through: :company_specialties_companies
end
