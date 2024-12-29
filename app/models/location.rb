# frozen_string_literal: true

class Location < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :parent, class_name: 'Location', optional: true
  has_many :children, class_name: 'Location', foreign_key: 'parent_id', dependent: :destroy

  validates :name, presence: true
  validates :location_type, presence: true, inclusion: { in: %w[Country State City] }
  validates :code, uniqueness: { scope: :location_type, allow_nil: true }

  scope :countries, -> { where(location_type: 'Country') }
  scope :states, -> { where(location_type: 'State') }
  scope :cities, -> { where(location_type: 'City') }

  def country?
    location_type == 'Country'
  end

  def state?
    location_type == 'State'
  end

  def city?
    location_type == 'City'
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
  #     t.string 'location_type'
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
    def find_or_create_by_name_and_type(location_param, company, location_type, parent = nil,
                                        job_post = nil)
      return nil if location_param.blank?

      normalized_name = location_param.strip.downcase
      parent_id = if parent.is_a?(Array)
                    parent.first.is_a?(Location) ? parent.first.id : nil
                  elsif parent.is_a?(Location)
                    parent.id
                  end

      existing_location = where(
        '(LOWER(name) = ? OR ? = ANY(aliases) OR LOWER(code) = ?) AND location_type = ?',
        normalized_name, normalized_name, normalized_name, location_type
      ).where(parent_id: parent_id).first

      return existing_location if existing_location

      unless location_type == 'Country' || parent_id.present?
        puts "#{RED}Parent location is missing for #{location_param} (#{location_type}).#{RESET}"
        return nil
      end

      error_message = "#{location_type} '#{location_param}' not found for job #{job_post} or company: #{company}"
      adj_type = job_post ? 'Location' : 'Company'

      puts "#{RED}#{error_message}.#{RESET}"
      if location_type.present? && (location_type == 'Country' || parent_id.present?)

        new_location = Location.create!(
          name: location_param,
          location_type: location_type,
          code: nil,
          parent_id: parent_id,
          aliases: [],
          error_details: error_message,
          resolved: false
        )

        Adjudication.log_error(
          adjudicatable_type: adj_type,
          adjudicatable_id: new_location.id,
          error_details: error_message
        )
        return new_location
      end
      nil
    end

    def find_by_name_and_type(name, location_type, parent = nil)
      normalized_name = name.strip.downcase
      parent_id = parent&.id

      where(
        '(LOWER(name) = ? OR ? = ANY(aliases) OR LOWER(code) = ?) AND location_type = ?',
        normalized_name, normalized_name, normalized_name, location_type
      ).where(parent_id: parent_id).first
    end
  end
end
