# frozen_string_literal: true

class CompanyDomain < ApplicationRecord
  belongs_to :company
  belongs_to :healthcare_domain
end
