class Country < ApplicationRecord
    has_many :companies
    has_many :job_posts
has_many :adjudications, as: :adjudicatable, dependent: :destroy 
  
    validates :country_code, presence: true, uniqueness: true
end