class CompanyType < ApplicationRecord
  has_many :company_specialties, dependent: :destroy
end