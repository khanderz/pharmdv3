# frozen_string_literal: true

class JobSetting < ApplicationRecord
  has_many :job_posts

  validates :setting_name, presence: true, uniqueness: true

  def self.find_setting(setting_name)
    where('LOWER(setting_name) = ?', setting_name.downcase)
      .or(
        where('EXISTS (SELECT 1 FROM UNNEST(aliases) AS alias WHERE LOWER(alias) = ?)',
              setting_name.downcase)
      ).first
  end
end
