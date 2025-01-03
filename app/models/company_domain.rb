# frozen_string_literal: true

class CompanyDomain < ApplicationRecord
  belongs_to :company
  belongs_to :healthcare_domain

  validates :company_id, presence: true
  validates :healthcare_domain_id, presence: true
end
