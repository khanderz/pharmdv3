# frozen_string_literal: true

class Skill < ApplicationRecord
  has_many :skill_resources, dependent: :destroy
  has_many :resources, through: :skill_resources
  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills
  validates :name, presence: true, uniqueness: true
  validates :skill_type, presence: true
end
