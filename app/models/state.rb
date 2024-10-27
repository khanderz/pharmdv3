# frozen_string_literal: true

class State < ApplicationRecord
  has_many :companies
  has_many :job_posts

  validates :state_name, presence: true, uniqueness: true
end
