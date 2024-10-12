class Company < ApplicationRecord
  belongs_to :company_specialty
  belongs_to :company_type
end
