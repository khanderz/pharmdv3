# app/models/company_type.rb
class CompanyType < ApplicationRecord
    validates :key, presence: true, uniqueness: true
    validates :value, presence: true
  end
  