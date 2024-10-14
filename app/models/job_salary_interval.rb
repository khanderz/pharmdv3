class JobSalaryInterval < ApplicationRecord
    has_many :job_posts

    validates :interval, presence: true, uniqueness: true
end
