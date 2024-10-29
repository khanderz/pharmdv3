class State < ApplicationRecord
  has_many :company_states, dependent: :destroy
  has_many :companies, through: :company_states
  has_many :job_post_states, dependent: :destroy
  has_many :job_posts, through: :job_post_states
  has_many :adjudications, as: :adjudicatable, dependent: :destroy
  validates :state_name, presence: true, uniqueness: true
end
