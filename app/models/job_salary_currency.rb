class JobSalaryCurrency < ApplicationRecord
    has_many :job_posts
    has_many :adjudications, as: :adjudicatable, dependent: :destroy 
    validates :currency_code, presence: true, uniqueness: true
end