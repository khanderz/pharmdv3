class JobSalaryCurrenciesController < ApplicationController
  def index
    currencies = JobSalaryCurrency.all.map do |currency|
      { key: currency.id, label: currency.currency_code } 
    end
    render json: currencies, status: :ok
  end
end
