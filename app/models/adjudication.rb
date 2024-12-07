# frozen_string_literal: true

class Adjudication < ApplicationRecord
  belongs_to :adjudicatable, polymorphic: true
end
