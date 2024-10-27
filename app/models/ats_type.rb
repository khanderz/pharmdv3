# frozen_string_literal: true

class AtsType < ApplicationRecord
  has_many :companies

  validates :ats_type_code, presence: true, uniqueness: true
  validates :ats_type_name, presence: true
end
