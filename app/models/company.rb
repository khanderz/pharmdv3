
# frozen_string_literal: true
class Company < ApplicationRecord
  has_paper_trail ignore: [:updated_at]

  belongs_to :ats_type
  belongs_to :company_size, optional: true
  belongs_to :funding_type, optional: true

  has_many :company_cities, dependent: :destroy
  has_many :cities, through: :company_cities, dependent: :destroy
  has_many :company_states, dependent: :destroy
  has_many :states, through: :company_states, dependent: :destroy
  has_many :company_countries, dependent: :destroy
  has_many :countries, through: :company_countries, dependent: :destroy
  has_many :company_domains
  has_many :healthcare_domains, through: :company_domains
  has_many :adjudications, as: :adjudicatable, dependent: :destroy
  has_many :job_posts, dependent: :destroy
  has_many :company_specializations
  has_many :company_specialties, through: :company_specializations

  validates :company_name, presence: true, uniqueness: true
  validates :linkedin_url, uniqueness: true, allow_blank: true
   
  def self.seed_existing_companies(company, row, ats_type, countries, states, cities)
    changes_made = false
    if company.operating_status != ActiveModel::Type::Boolean.new.cast(row['operating_status'])
      company.operating_status = ActiveModel::Type::Boolean.new.cast(row['operating_status'])
      changes_made = true
    end

    if company.linkedin_url != row['linkedin_url']
      company.linkedin_url = row['linkedin_url']
      changes_made = true
    end

    if company.is_public != ActiveModel::Type::Boolean.new.cast(row['is_public'])
      company.is_public = ActiveModel::Type::Boolean.new.cast(row['is_public'])
      changes_made = true
    end

    if company.year_founded != row['year_founded'].to_i
      company.year_founded = row['year_founded'].to_i
      changes_made = true
    end

    if company.acquired_by != row['acquired_by']
      company.acquired_by = row['acquired_by']
      changes_made = true
    end

    if company.company_description != row['company_description']
      company.company_description = row['company_description']
      changes_made = true
    end

    if company.ats_id != row['ats_id']
      company.ats_id = row['ats_id']
      changes_made = true
    end

    if ats_type && ats_type[:ats_type_code] != row['company_ats_type']
      company.ats_type = ats_type
      changes_made = true
    end

    if company.countries.pluck(:id).sort != countries.pluck(:id).sort
      company.countries = countries
      changes_made = true
    end

    if states.present? && company.states.pluck(:id).sort != states.pluck(:id).sort
      company.states = states
      changes_made = true
    end

    if company.cities.pluck(:id).sort != cities.pluck(:id).sort
      company.cities = cities
      changes_made = true
    end

    # Optional attributes
    if row['company_size'].present?
      company_size = CompanySize.find_by(size_range: row['company_size'])
      if company_size && company.company_size&.size_range != company_size.size_range
        company.company_size = company_size
        changes_made = true
      end
    end
    if row['last_funding_type'].present?
      funding_type = FundingType.find_by(funding_type_name: row['last_funding_type'])
      if funding_type && company.funding_type&.funding_type_name != funding_type.funding_type_name
        company.funding_type = funding_type
        changes_made = true
      end
    end

    if row['logo_url'].present? && company.logo_url != row['logo_url']
      company.logo_url = row['logo_url']
      changes_made = true
    end

    if row['company_url'].present? && company.company_url != row['company_url']
      company.company_url = row['company_url']
      changes_made = true
    end
    # Handling multiple healthcare domains
    if row['healthcare_domains'].present?
      healthcare_domains = row['healthcare_domains'].split(',').map(&:strip)
      domains = healthcare_domains.map do |domain_key|
        HealthcareDomain.find_by(key: domain_key)
      end.compact
      if domains.present? && company.healthcare_domains.pluck(:id).sort != domains.pluck(:id).sort
        company.healthcare_domains = domains
        changes_made = true
      end
    else
      puts "No healthcare domains found for company: #{row['company_name']}"
    end
    # Company specialties based on the found healthcare domains
    if row['company_specialty'].present? && domains.present?
      specialties = row['company_specialty'].split(',').map do |specialty_key|
        CompanySpecialty.find_by(key: specialty_key.strip)
      end.compact
      if specialties.present? && company.company_specialties.pluck(:id).sort != specialties.pluck(:id).sort
        company.company_specialties = specialties
        changes_made = true
      end
    else
      puts "No specialties found for company: #{row['company_name']} or no valid healthcare domains."
    end
    changes_made
  end
  
  def populate_missing_data
    data = {
      company_name: self.company_name,
      operating_status: self.operating_status,
      industry: self.healthcare_domains.map(&:key).join(','),
      company_ats_type: self.ats_type&.ats_type_code,
      company_size: self.company_size&.size_range,
      healthcare_domain: self.healthcare_domains.present? ? self.healthcare_domains.map(&:key).join(',') : nil,
      company_specialty: self.company_specialties.present? ? self.company_specialties.map(&:key).join(',') : nil
    }
    processed_data = DataProcessingService.predict_company_attributes(data)
    self.company_size ||= processed_data[:predicted_size]
    self.healthcare_domains << HealthcareDomain.find_by(key: processed_data[:predicted_healthcare_domain]) if self.healthcare_domains.empty?
    self.company_specialties << CompanySpecialty.find_by(key: processed_data[:predicted_company_specialty]) if self.company_specialties.empty?
    self.save
  end
  
end
