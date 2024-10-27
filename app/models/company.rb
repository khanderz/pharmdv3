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

  def self.seed_existing_companies(company, row, ats_type, country)
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
    if country && (country[:country_code] != row['company_country'] && country[:country_name] != row['company_country'] && !country.aliases.include?(row['company_country']))
      company.country = country
      changes_made = true
    end
    if row['company_state'].present?
      state = State.find_by(state_name: row['company_state']) || State.find_by(state_code: row['company_state'])
      if state && state != company.state
        company.state = state
        changes_made = true
      end
    end
    if row['company_city'].present?
      city = City.find_by(city_name: row['company_city']) || City.where('? = ANY (aliases)',
                                                                        row['company_city']).first
      if city && city != company.city
        company.city = city
        changes_made = true
      elsif city.nil?
        new_city = City.create!(
          city_name: row['company_city'],
          error_details: "City '#{row['company_city']}' not found for Company #{row['company_name']}",
          resolved: false
        )
        Adjudication.create!(
          adjudicatable_type: 'Company',
          adjudicatable_id: new_city.id,
          adjudicatable: new_city,
          error_details: "City '#{row['company_city']}' not found for Company #{row['company_name']}",
          resolved: false
        )
        puts "City '#{row['company_city']}' not found for company #{row['company_name']}. Logged to adjudications."
      end
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
end
