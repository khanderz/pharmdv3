# frozen_string_literal: true

class CompanyCountry < ApplicationRecord
  belongs_to :company
  belongs_to :country
end
