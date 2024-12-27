# frozen_string_literal: true

class CompanyLocation < ApplicationRecord
  belongs_to :company
  belongs_to :location
end
