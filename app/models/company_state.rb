# frozen_string_literal: true

class CompanyState < ApplicationRecord
  belongs_to :company
  belongs_to :state
end
