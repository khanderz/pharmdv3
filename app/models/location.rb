# frozen_string_literal: true

class Location < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :parent, class_name: 'Location', optional: true
  has_many :children, class_name: 'Location', foreign_key: 'parent_id', dependent: :destroy

  validates :name, presence: true
  validates :location_type, inclusion: { in: %w[Country State City Continent] }
  validates :code, uniqueness: { scope: :location_type, allow_nil: true }

  scope :continents, -> { where(location_type: 'Continent') }
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
    hierarchy = []
    current_location = self
    while current_location
      hierarchy.unshift(current_location.name)
      current_location = current_location.parent
    end
    hierarchy.join(' > ')
  end

  class << self
    def find_or_create_by_name_and_type(location_param, company, location_type, parent = nil,
                                        job_post = nil)
      puts "location_param: #{location_param}, location_type: #{location_type}, company_name: #{company}, parent: #{parent}"

      return nil if location_param.blank?

      normalized_name = normalize_name(location_param)
      parent_id = extract_parent_id(parent)

      puts "#{BLUE}normalized_name #{normalized_name}#{RESET}"
      puts "#{BLUE}parent_id #{parent_id}#{RESET}"

      existing_location = find_location_by_name_or_alias(normalized_name, location_type, parent_id)

      puts "existing location #{existing_location}"

      return existing_location if existing_location

      create_new_location(location_param, location_type, parent_id, company, job_post)
    end

    def find_by_name_and_type(name, location_type, parent = nil)
      normalized_name = normalize_name(name)
      parent_id = extract_parent_id(parent)
      # puts "#{BLUE}# location_type #{location_type}  normalized_name #{normalized_name} parent_id: #{parent_id}#{RESET}"

      find_location_by_name_or_alias(normalized_name, location_type, parent_id)
    end

    private

    def normalize_name(name)
      name.to_s.strip.downcase
    end

    def extract_parent_id(parent)
      if parent.is_a?(Location)
        parent.id
      elsif parent.is_a?(Array) && parent.first.is_a?(Location)
        parent.first.id
      end
    end

    def find_location_by_name_or_alias(normalized_name, location_type, parent_id)
      parent_condition = parent_id ? { parent_id: parent_id } : {}
      # puts "parent_condition: #{parent_condition}"
      query = where(
        '(LOWER(name) = :name OR LOWER(code) = :name OR LOWER(:name) = ANY(ARRAY(SELECT LOWER(unnest(aliases))))) AND LOWER(location_type) = :type',
        name: normalized_name, type: location_type.downcase
      ).where(parent_condition)

      # puts "Generated query: #{query.to_sql}"
      query.first
    end

    def create_new_location(location_param, location_type, parent_id, company, job_post)
      error_message = "#{location_type} '#{location_param}' not found for job #{job_post} or company: #{company}"
      adj_type = job_post ? 'Location' : 'Company'

      puts "#{RED}#{error_message}.#{RESET}"

      begin
        new_location = Location.create!(
          name: location_param,
          location_type: location_type,
          code: nil,
          parent_id: parent_id,
          aliases: [],
          error_details: error_message,
          resolved: false
        )

        if adj_type == 'Company' && new_location.persisted?
          Adjudication.log_error(
            adjudicatable_type: adj_type,
            adjudicatable_id: new_location.id,
            error_details: error_message
          )
        end

        new_location
      rescue ActiveRecord::RecordNotUnique
        puts "#{ORANGE}Duplicate detected. Fetching existing record...#{RESET}"
        find_location_by_name_or_alias(normalize_name(location_param), location_type, parent_id)
      rescue ActiveRecord::RecordInvalid => e
        puts "#{RED}Failed to create location: #{e.message}.#{RESET}"
        nil
      end
    end
  end
end
