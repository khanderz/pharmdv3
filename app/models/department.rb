class Department < ApplicationRecord
    has_many :job_posts
    has_many :adjudications, as: :adjudicatable, dependent: :destroy 
    validates :dept_name, presence: true, uniqueness: true
end