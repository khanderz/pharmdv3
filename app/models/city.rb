# frozen_string_literal: true

class City < ApplicationRecord
  has_many :companies
  has_many :adjudications, as: :adjudicatable, dependent: :destroy
  has_many :job_posts

  validates :city_name, presence: true, uniqueness: true
end
