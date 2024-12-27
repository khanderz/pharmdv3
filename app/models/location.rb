# frozen_string_literal: true

class Location < ApplicationRecord
  belongs_to :parent, class_name: 'Location', optional: true
  has_many :children, class_name: 'Location', foreign_key: 'parent_id', dependent: :destroy

  validates :name, presence: true
  validates :type, presence: true, inclusion: { in: %w[Country State City] }
  validates :code, uniqueness: { scope: :type, allow_nil: true }

  scope :countries, -> { where(type: 'Country') }
  scope :states, -> { where(type: 'State') }
  scope :cities, -> { where(type: 'City') }

  def country?
    type == 'Country'
  end

  def state?
    type == 'State'
  end

  def city?
    type == 'City'
  end

  def full_hierarchy
    # ex: "United States > California > Los Angeles"
    hierarchy = []
    current_location = self
    while current_location
      hierarchy.unshift(current_location.name)
      current_location = current_location.parent
    end
    hierarchy.join(' > ')
  end

  class << self
    def find_or_create_by_name_and_type(name, type, attributes = {})
      normalized_name = name.strip.downcase
      location = where('LOWER(name) = ? OR ? = ANY(aliases)', normalized_name,
                       normalized_name).find_by(type: type)

      location ||= create!(
        name: attributes[:name] || name,
        type: type,
        code: attributes[:code],
        parent_id: attributes[:parent_id],
        aliases: attributes[:aliases] || []
      )

      location
    end

    def find_by_name_and_type(name, type)
      normalized_name = name.strip.downcase
      where('LOWER(name) = ? OR ? = ANY(aliases)', normalized_name,
            normalized_name).find_by(type: type)
    end
  end
end
