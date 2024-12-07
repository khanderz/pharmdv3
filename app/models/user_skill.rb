# frozen_string_literal: true

class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill
end
