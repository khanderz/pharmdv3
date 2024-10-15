class Country < ApplicationRecord
    has_many :companies
    has_many :job_posts
    has_many :adjudications, as: :adjudicatable, dependent: :destroy 
  
    validates :country_code, presence: true, uniqueness: true
  
    def self.find_or_adjudicate_country(country_code, country_name, company_id, job_url)
        country = Country.find_by(country_code: country[:country_code]) ||
                    Country.find_by(country_name: country[:country_name]) ||
                    Country.where('? = ANY(aliases)', country[:country_name]).first

      unless country
        Adjudication.create!(
          adjudicatable_type: 'JobPost',
          adjudicatable_id: country.id,  
          error_details: "Country with code '#{country_code}' or name '#{country_name}' not found for Company ID #{company_id}, Job URL #{job_url}",
          resolved: false
        )

        puts "--------Country with code '#{country_code}' or name '#{country_name}' not found. Logged to adjudications."
        return nil
      end
      
      country
    end
  end
  