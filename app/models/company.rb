# frozen_string_literal: true

class Company < ApplicationRecord
  has_paper_trail ignore: [:updated_at]

  # Associations
  belongs_to :ats_type
  belongs_to :company_size, optional: true
  belongs_to :funding_type, optional: true
  belongs_to :company_type, optional: true

  has_many :company_cities, dependent: :destroy
  has_many :cities, through: :company_cities

  has_many :company_states, dependent: :destroy
  has_many :states, through: :company_states

  has_many :company_countries, dependent: :destroy
  has_many :countries, through: :company_countries

  has_many :company_domains, dependent: :destroy
  has_many :healthcare_domains, through: :company_domains

  has_many :company_specializations, dependent: :destroy
  has_many :company_specialties, through: :company_specializations

  has_many :adjudications, as: :adjudicatable, dependent: :destroy
  has_many :job_posts, dependent: :destroy

  # Validations
  validates :company_name, presence: true, uniqueness: true
  validates :linkedin_url, uniqueness: true, allow_blank: true
  validates :company_url, uniqueness: true, allow_blank: true

  # Scopes
  scope :with_size, ->(size) { where(company_size_id: size.id) }
  scope :operating, -> { where(operating_status: true) }
  scope :by_country, ->(country_id) { joins(:company_countries).where(company_countries: { country_id: country_id }) }
  scope :by_state, ->(state_id) { joins(:company_states).where(company_states: { state_id: state_id }) }
  scope :by_city, ->(city_id) { joins(:company_cities).where(company_cities: { city_id: city_id }) }
  scope :by_healthcare_domain, ->(domain_id) { joins(:company_domains).where(company_domains: { healthcare_domain_id: domain_id }) }
  scope :by_specialty, ->(specialty_id) { joins(:company_specializations).where(company_specializations: { company_specialty_id: specialty_id }) }

  # Instance Methods
  def full_location
    locations = []
    locations << cities.pluck(:city_name).join(', ') if cities.any?
    locations << states.pluck(:state_name).join(', ') if states.any?
    locations << countries.pluck(:country_name).join(', ') if countries.any?
    locations.join(' - ')
  end

  def active_jobs
    job_posts.where(job_active: true)
  end

  def inactive_jobs
    job_posts.where(job_active: false)
  end

  def self.seed_existing_companies(company, row, ats_type, countries, states, cities)
    changes_made = false
    %w[operating_status linkedin_url year_founded acquired_by company_description ats_id logo_url
       company_url].each do |attribute|
      next unless row[attribute].present?

      casted_value = case attribute
                     when 'operating_status'
                       ActiveModel::Type::Boolean.new.cast(row[attribute])
                     when 'year_founded'
                       row[attribute].to_i
                     else
                       row[attribute]
                     end
      if company[attribute] != casted_value
        company[attribute] = casted_value
        changes_made = true
      end
    end
    # Update associations
    changes_made ||= update_association(company, :ats_type, ats_type)
    changes_made ||= update_collection(company, :countries, countries)
    changes_made ||= update_collection(company, :states, states)
    changes_made ||= update_collection(company, :cities, cities)
    # Update optional attributes
    changes_made ||= update_optional_association(company, :company_size, row['company_size'],
                                                 CompanySize, :size_range)
    changes_made ||= update_optional_association(company, :funding_type, row['last_funding_type'],
                                                 FundingType, :funding_type_name)
    # Update healthcare domains
    if row['healthcare_domains'].present?
      healthcare_domains = row['healthcare_domains'].split(',').map(&:strip)
      domains = healthcare_domains.map do |domain_key|
        HealthcareDomain.find_by(key: domain_key)
      end.compact
      changes_made ||= update_collection(company, :healthcare_domains, domains)
    else
      puts "No healthcare domains found for company: #{row['company_name']}"
    end
    # Update specialties
    if row['company_specialty'].present?
      specialties = row['company_specialty'].split(',').map do |specialty_key|
        CompanySpecialty.find_by(key: specialty_key.strip)
      end.compact
      changes_made ||= update_collection(company, :company_specialties, specialties)
    else
      puts "No specialties found for company: #{row['company_name']}"
    end
    changes_made
  end
  private_class_method def self.update_association(company, association, new_value)
    return false if company.send(association) == new_value

    company.send("#{association}=", new_value)
    true
  end
  private_class_method def self.update_optional_association(company, association, new_value_key, model_class, key_field)
    return false unless new_value_key.present?

    new_value = model_class.find_by(key_field => new_value_key)
    return false if company.send(association) == new_value

    company.send("#{association}=", new_value)
    true
  end
  private_class_method def self.update_collection(company, association, new_values)
    if new_values.blank? || company.send(association).pluck(:id).sort == new_values.pluck(:id).sort
      return false
    end

    company.send("#{association}=", new_values)
    true
  end
end
