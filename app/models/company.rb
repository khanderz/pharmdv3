# app/models/company.rb
class Company < ApplicationRecord
    has_many :job_posts, foreign_key: :companies_id, dependent: :destroy

    belongs_to :company_type, optional: true

    # Access the company type value
    def company_type_name
      company_type&.value
    end
  end
  