# frozen_string_literal: true

class CompanyCity < ApplicationRecord
  belongs_to :company
  belongs_to :city
end
