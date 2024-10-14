class JobSalaryCurrency < ApplicationRecord
    has_many :job_posts

    validates :currency_code, presence: true, uniqueness: true
end
