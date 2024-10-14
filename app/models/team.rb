class Team < ApplicationRecord
    has_many :job_posts
    validates :team_name, presence: true, uniqueness: true
end