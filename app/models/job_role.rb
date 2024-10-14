class JobRole < ApplicationRecord
  belongs_to :department
  belongs_to :team
end
