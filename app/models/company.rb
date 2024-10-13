# app/models/company.rb
class Company < ApplicationRecord
  has_many :job_posts, foreign_key: :companies_id, dependent: :destroy
  
   has_many :company_specializations 
   has_many :company_specialties, through: :company_specializations
  
  belongs_to :company_type
  validate :validate_specialty_against_type
  def validate_specialty_against_type
    allowed_specialties = CompanySpecialty.where(company_type_id: company_type.id).pluck(:key)
    company_specialties.each do |specialty|
      unless allowed_specialties.include?(specialty.key)
        errors.add(:company_specialty, "#{specialty.key} is not valid for the selected company type")
      end
    end
  end
end