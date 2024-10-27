# frozen_string_literal: true

class CompanySpecialization < ApplicationRecord
  belongs_to :company
  belongs_to :company_specialty
end
