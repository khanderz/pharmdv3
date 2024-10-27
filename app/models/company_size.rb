# frozen_string_literal: true

class CompanySize < ApplicationRecord
  has_many :companies
  validates :size_range, presence: true, uniqueness: true
end
