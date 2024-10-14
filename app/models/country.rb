class Country < ApplicationRecord
    has_many :companies
    has_many :job_posts
  
    validates :country_code, presence: true, uniqueness: true
end
