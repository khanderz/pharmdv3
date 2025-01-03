# frozen_string_literal: true

class Company < ApplicationRecord
  has_paper_trail ignore: [:updated_at]

  # Associations
  belongs_to :ats_type
  belongs_to :company_size, optional: true
  belongs_to :funding_type, optional: true
  belongs_to :company_type, optional: true

  has_many :company_locations, dependent: :destroy
  has_many :locations, through: :company_locations

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
  validates :ats_type_id, presence: true

  # Scopes
  scope :with_size, ->(size) { where(company_size_id: size.id) }
  scope :operating, -> { where(operating_status: true) }
  scope :by_location, lambda { |location_id|
    joins(:company_locations).where(company_locations: { location_id: location_id })
  }

  scope :by_healthcare_domain, lambda { |domain_id|
    joins(:company_domains).where(company_domains: { healthcare_domain_id: domain_id })
  }
  scope :by_specialty, lambda { |specialty_id|
    joins(:company_specializations).where(company_specializations: { company_specialty_id: specialty_id })
  }

  # Instance Methods
  def active_jobs
    job_posts.where(job_active: true)
  end

  def inactive_jobs
    job_posts.where(job_active: false)
  end

  # Class Methods
  def self.seed_existing_companies(company, row, ats_type, locations)
    changes_made = false
    %w[operating_status linkedin_url year_founded acquired_by company_description ats_id logo_url
       company_url].each do |attribute|
      next unless row[attribute].present?

      casted_value = case attribute
                     when 'operating_status', 'is_completely_remote'
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

    changes_made ||= update_association(company, :ats_type, ats_type)
    changes_made ||= update_collection(company, :locations, locations)

    changes_made ||= update_optional_association(company, :company_size, row['company_size'],
                                                 CompanySize, :size_range)
    changes_made ||= update_optional_association(company, :funding_type, row['last_funding_type'],
                                                 FundingType, :funding_type_name)

    if row['healthcare_domain'].present?
      healthcare_domains = row['healthcare_domain'].split(',').map(&:strip)
      puts "Healthcare Domains: #{healthcare_domains}"

      domains = healthcare_domains.map do |domain_key|
        HealthcareDomain.find_by(key: domain_key)
      end.compact
      puts "Found Healthcare Domains: #{domains.map(&:id)}"

      domains.each do |domain|
        CompanyDomain.find_or_create_by!(company: company, healthcare_domain: domain)
        puts "Created CompanyDomain for Company #{company.id} and HealthcareDomain #{domain.id}"
      end

      changes_made ||= domains.any?

    else
      puts "No healthcare domains found for company: #{row['company_name']}"
    end

    if row['company_specialty'].present?
      specialties = row['company_specialty'].split(',').map do |specialty_key|
        CompanySpecialty.find_by(key: specialty_key.strip)
      end.compact
      changes_made ||= update_collection(company, :company_specialties, specialties)
    else
      puts "No specialties found for company: #{row['company_name']}"
    end

    company.save! if changes_made
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
   puts "-----------UPDATING"
    current_ids = company.send(association).pluck(:id).sort
    new_ids = new_values.pluck(:id).sort
    puts "Updating #{association}: current IDs: #{current_ids}, new IDs: #{new_ids}"

    if new_values.blank? || current_ids == new_ids
      puts "No changes needed for #{association}"
      return false
    end

    begin
      company.send("#{association}=", new_values)
      if company.save
        puts "#{association} after save: #{company.send(association).pluck(:id)}"
      else
        puts "Failed to save #{association}: #{company.errors.full_messages}"
      end
      company.reload
      true
    rescue ActiveRecord::RecordInvalid => e
      puts "Failed to update #{association}: #{e.message}"
      false
    end
  end
end
