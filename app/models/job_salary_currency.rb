# app/models/job_salary_currency.rb
class JobSalaryCurrency < ApplicationRecord
  has_many :job_posts
  has_many :adjudications, as: :adjudicatable, dependent: :destroy

  validates :currency_code, presence: true, uniqueness: true
  validates :currency_sign, presence: true, uniqueness: true

  def self.find_or_adjudicate_currency(identifier, company_id, job_url)
    return nil if identifier.nil?

    currency = JobSalaryCurrency.find_by(currency_code: identifier) || JobSalaryCurrency.find_by(currency_sign: identifier)

    unless currency
      new_currency = JobSalaryCurrency.create!(
        currency_code: identifier,
        error_details: "Currency with code or symbol '#{identifier}' not found and needs adjudication.",
        resolved: false
      )
      Adjudication.create!(
        adjudicatable_type: 'JobPost',
        adjudicatable_id: new_currency.id,
        error_details: "Currency with identifier '#{identifier}' not found for Company ID #{company_id}, Job URL #{job_url}",
        resolved: false
      )
      puts "--------Currency with identifier '#{identifier}' not found. Logged to adjudications."
      return nil
    end
    currency
  end

  def self.find_by_symbol(symbol)
    find_by(currency_sign: symbol)
  end
end
