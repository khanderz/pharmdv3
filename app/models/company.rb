class Company < ApplicationRecord
  belongs_to :ats_type
  belongs_to :company_size
  belongs_to :funding_type
end
