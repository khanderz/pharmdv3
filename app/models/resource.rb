class Resource < ApplicationRecord
  has_many :skill_resources, dependent: :destroy
  has_many :skills, through: :skill_resources

  has_many :user_resources, dependent: :destroy
  has_many :users, through: :user_resources

  validates :name, presence: true
  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }
end
