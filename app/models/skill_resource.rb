# frozen_string_literal: true

class SkillResource < ApplicationRecord
  belongs_to :skill
  belongs_to :resource
end
