# job_salary_currency.rb

class JobSalaryCurrency < ApplicationRecord
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :currency_code, presence: true, uniqueness: true

  def self.find_or_adjudicate_currency(currency_code, company_id, job_url, job_post = nil)
    return nil if currency_code.nil?

    currency = find_by(currency_code: currency_code)
    return currency if currency

    # Fallback to JobPostService to try extracting currency code if job_post provided
    if job_post && (extracted_currency_code = JobPostService.extract_currency_from_text(job_post))
      currency = find_by(currency_code: extracted_currency_code)
      return currency if currency
    end

    # If currency still not found, create an adjudication entry
    new_currency = create!(
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
    nil
  end
end
