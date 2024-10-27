# frozen_string_literal: true

class Adjudication < ApplicationRecord
  belongs_to :adjudicatable, polymorphic: true

  validates :adjudicatable_type, :adjudicatable_id, presence: true
  validates :error_details, presence: true

  scope :unresolved, -> { where(resolved: false) }
end
