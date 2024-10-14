class Company < ApplicationRecord
  belongs_to :company_ats_type
  belongs_to :company_size
  belongs_to :funding_type
  belongs_to :company_city
  belongs_to :company_state
  belongs_to :company_country
  belongs_to :company_type
end
