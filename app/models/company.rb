# app/models/company.rb
class Company < ApplicationRecord
    has_many :job_posts, foreign_key: :companies_id, dependent: :destroy
  end
  