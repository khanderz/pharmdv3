class JobSalaryCurrency < ApplicationRecord
    has_many :job_posts
    has_many :adjudications, as: :adjudicatable, dependent: :destroy 
    validates :currency_code, presence: true, uniqueness: true
    def self.find_or_adjudicate_currency(currency_code, company_id, job_url)
        if currency_code.nil?
            return nil
          end
        currency = JobSalaryCurrency.find_by(currency_code: currency_code)
        unless currency
            new_currency = JobSalaryCurrency.create!(
                currency_code: currency_code,
                error_details: "Currency #{currency_code} not found and needs adjudication.",
                resolved: false
              )
            Adjudication.create!(
                adjudicatable_type: 'JobPost',
                adjudicatable_id: new_currency.id,  
                error_details: "Currency with code '#{currency_code}' not found for Company ID #{company_id}, Job URL #{job_url}",
                resolved: false
            )
            puts "--------Currency with code '#{currency_code}' not found. Logged to adjudications."
            return nil
        end
    currency
end
end