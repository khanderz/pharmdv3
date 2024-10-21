class CompanySpecialtiesController < ApplicationController
    def index
      specialties = CompanySpecialty.joins("INNER JOIN healthcare_domains ON company_specialties.healthcare_domain_id = healthcare_domains.id")
                                    .select("company_specialties.value AS specialty_value, healthcare_domains.key AS domain_key")
  
      render json: specialties.map { |specialty| { value: specialty.specialty_value, domain_key: specialty.domain_key } }
    end
  end
  