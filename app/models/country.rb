# frozen_string_literal: true

class Country < ApplicationRecord
  has_many :company_countries, dependent: :destroy
  has_many :companies, through: :company_countries
  has_many :job_post_countries, dependent: :destroy
  has_many :job_posts, through: :job_post_countries
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :country_code, presence: true,
                           uniqueness: true

  def self.find_or_adjudicate_country(country_code, country_name, company, job_url = nil)
    return nil if country_code.blank? && country_name.blank?

    country_code_down = country_code&.downcase
    country_name_down = country_name&.downcase

    country = where('LOWER(country_code) = ?', country_code_down)
              .or(where('LOWER(country_name) = ?', country_name_down))
              .or(
                where('EXISTS (SELECT 1 FROM UNNEST(aliases) AS alias WHERE LOWER(alias) = ?)',
                      country_name_down)
              ).first

    unless country
      puts "#{RED}Country with code '#{country_code}' or name '#{country_name}' not found for Company #{company}, Job URL #{job_url}.#{RESET}"
      error_details = "Country with code '#{country_code}' or name '#{country_name}' not found for Company #{company}, Job URL #{job_url}"
      adj_type = job_url ? 'Country' : 'Company'

      new_country = Country.create!(
        country_code: country_code,
        country_name: country_name,
        error_details: error_details,
        resolved: false
      )
      Adjudication.log_error(
        adjudicatable_type: adj_type,
        adjudicatable_id: new_country.id,
        error_details: error_details
      )

      return nil
    end
    country
  end

  def self.find_country_only(country_code, country_name)
    country_code_down = country_code&.downcase
    country_name_down = country_name&.downcase

    country = where('LOWER(country_code) = ?', country_code_down)
              .or(where('LOWER(country_name) = ?', country_name_down))
              .or(
                where('EXISTS (SELECT 1 FROM UNNEST(aliases) AS alias WHERE LOWER(alias) = ?)',
                      country_name_down)
              ).first

    country || nil
  end
end
