class JobSetting < ApplicationRecord
    has_many :job_posts

    validates :setting_name, presence: true, uniqueness: true
end
