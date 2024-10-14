class Company < ApplicationRecord
  has_paper_trail ignore: [:updated_at]
  belongs_to :ats_type
  belongs_to :company_size, optional: true
  belongs_to :funding_type, optional: true
  belongs_to :city, optional: true
  belongs_to :state, optional: true
  belongs_to :country
  belongs_to :healthcare_domain, foreign_key: 'healthcare_domain_id', class_name: 'HealthcareDomain'
  has_many :job_posts, foreign_key: :company_id, dependent: :destroy
  has_many :company_specializations 
  has_many :company_specialties, through: :company_specializations
  validates :company_name, presence: true, uniqueness: true
  validates :linkedin_url, uniqueness: true, allow_blank: true
end
