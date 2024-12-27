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

  #   create_table 'locations', force: :cascade do |t|
  #     t.string 'name'
  #     t.string 'type'
  #     t.string 'code'
  #     t.bigint 'parent_id'
  #     t.string 'aliases', default: [], array: true
  #     t.text 'error_details'
  #     t.bigint 'reference_id'
  #     t.boolean 'resolved'
  #     t.datetime 'created_at', null: false
  #     t.datetime 'updated_at', null: false
  #   end

  class << self
    def find_or_create_by_name_and_type(location_param, company, job_post = nil)
      return nil if location_param.blank?

      param = location_param.downcase
      types = %w[City State Country]

      types.each do |location_type|
        existing_location = find_by_name_and_type(param, location_type)
        return existing_location if existing_location

        error_message = "#{location_type} '#{location_param}' not found for job #{job_post} or company: #{company}"
        adj_type = job_post ? 'Location' : 'Company'

        puts "#{RED}#{error_message}.#{RESET}"

        new_location = Location.create!(
          name: location_param,
          type: location_type,
          code: nil,
          parent_id: nil,
          aliases: [],
          error_details: error_message,
          resolved: false
        )

        Adjudication.log_error(
          adjudicatable_type: adj_type,
          adjudicatable_id: new_location.id,
          error_details: error_message
        )
      end

      nil
    end

    def find_by_name_and_type(name, type)
      normalized_name = name.strip.downcase
      where('(LOWER(name) = ? OR ? = ANY(aliases) OR LOWER(code) = ?)',
            normalized_name, normalized_name, normalized_name).find_by(type: type)
    end
  end
end
