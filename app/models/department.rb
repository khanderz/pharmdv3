
class Department < ApplicationRecord
    has_many :job_posts
    validates :dept_name, presence: true, uniqueness: true
end