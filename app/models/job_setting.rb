# frozen_string_literal: true

class JobSetting < ApplicationRecord
  has_many :job_posts

  validates :setting_name, presence: true, uniqueness: true

  def self.find_setting(input)
    normalized_input = input.to_s.strip.downcase

    where(
      '(LOWER(setting_name) = ? OR ? = ANY(aliases))',
      normalized_input, normalized_input
    ).first
  rescue ActiveRecord::StatementInvalid => e
    Rails.logger.error "Error in JobSetting.find_setting: #{e.message}"
    nil
  end
end
