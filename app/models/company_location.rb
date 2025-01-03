# frozen_string_literal: true

class CompanyLocation < ApplicationRecord
  belongs_to :company
  belongs_to :location

  validates :company_id, uniqueness: { scope: :location_id }
end
