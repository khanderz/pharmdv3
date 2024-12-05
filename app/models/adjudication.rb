class Adjudication < ApplicationRecord
  belongs_to :adjudicatable, polymorphic: true
end
