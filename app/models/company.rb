class Company < ApplicationRecord
  belongs_to :ats_type
  belongs_to :company_size
  belongs_to :funding_type
  belongs_to :city
  belongs_to :state
  belongs_to :country
  belongs_to :healthcare_domain
end
