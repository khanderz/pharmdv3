# frozen_string_literal: true

class SavedCompany < ApplicationRecord
  belongs_to :user
  belongs_to :company
end
