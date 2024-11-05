# frozen_string_literal: true

class FundingType < ApplicationRecord
  has_many :companies
  validates :funding_type_name, presence: true, uniqueness: true
end
