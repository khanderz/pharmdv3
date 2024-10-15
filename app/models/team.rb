class Team < ApplicationRecord
    has_many :job_posts
    has_many :adjudications, as: :adjudicatable, dependent: :destroy 

    validates :team_name, presence: true, uniqueness: true
end