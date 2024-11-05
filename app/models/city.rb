# frozen_string_literal: true

class City < ApplicationRecord
  has_many :company_cities, dependent: :destroy
  has_many :companies, through: :company_cities
  has_many :job_post_cities, dependent: :destroy
  has_many :job_posts, through: :job_post_cities
  has_many :adjudications, as: :adjudicatable, dependent: :destroy
  validates :city_name, presence: true, uniqueness: true
end
