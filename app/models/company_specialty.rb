# frozen_string_literal: true

class CompanySpecialty < ApplicationRecord
  has_many :company_specializations
  has_many :companies, through: :company_specializations
  validates :key, :value, presence: true
  validates :key, uniqueness: true
end
