# frozen_string_literal: true

class AtsType < ApplicationRecord
  has_many :companies
  validates :ats_type_code, presence: true, uniqueness: true
  validates :ats_type_name, presence: true
  validates :domain_matched_url, presence: true
  validates :redirect_url, presence: true
end
