class JobRole < ApplicationRecord
  belongs_to :department
  belongs_to :team
  has_many :job_posts

  validates :role_name, presence: true, uniqueness: true
end
