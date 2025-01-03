# frozen_string_literal: true

class HealthcareDomain < ApplicationRecord
  has_many :company_domains, dependent: :destroy
  has_many :companies, through: :company_domains

  validates :key, presence: true, uniqueness: true
end
