class JobCommitment < ApplicationRecord
    has_many :job_posts

    validates :commitment_name, presence: true, uniqueness: true
end
