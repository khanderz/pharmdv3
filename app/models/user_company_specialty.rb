# frozen_string_literal: true

class UserCompanySpecialty < ApplicationRecord
  belongs_to :user
  belongs_to :company_specialty
end
