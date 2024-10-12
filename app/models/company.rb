# app/models/company.rb
class Company < ApplicationRecord
  has_many :job_posts, foreign_key: :companies_id, dependent: :destroy
  
  has_many :company_specialties_companies has_many :company_specialties, through: :company_specialties_companies

  has_one :company_type, through: :company_specialties 

  def validate_specialty_against_type allowed_specialties = case company_type.key when 'PHARMA' Company::PHARMACY_TYPES.keys when 'DIGITAL_HEALTH' Company::DIGITAL_HEALTH_TYPES.keys else [] end company_specialties.each do |specialty| unless allowed_specialties.include?(specialty.name) errors.add(:company_specialty, "#{specialty.name} is not valid for the selected company type") end end end


end