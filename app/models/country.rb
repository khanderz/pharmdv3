# frozen_string_literal: true

class Country < ApplicationRecord
  has_many :company_countries, dependent: :destroy
  has_many :companies, through: :company_countries
  has_many :job_post_countries, dependent: :destroy
  has_many :job_posts, through: :job_post_countries
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :country_code, presence: true,
                           uniqueness: true

  def self.find_or_adjudicate_country(country_code, country_name, company_id, job_url)
    country = Country.find_by(country_code: country_code) ||
              Country.find_by(country_name: country_name) ||
              Country.where('? = ANY(aliases)', country_name).first

    unless country
      new_country = Country.create!(
        country_code: country_code,
        country_name: country_name,
        error_details: "Country with code '#{country_code}' or name '#{country_name}' not found for Company ID #{company_id}, Job URL #{job_url}",
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: 'JobPost',
        adjudicatable_id: new_country.id,
        error_details: "Country with code '#{country_code}' or name '#{country_name}' not found for Company ID #{company_id}, Job URL #{job_url}"
      )

      return nil
    end
    country
  end
end
