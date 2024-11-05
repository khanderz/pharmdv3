# frozen_string_literal: true

class JobSalaryCurrenciesController < ApplicationController
  def index
    currencies = JobSalaryCurrency.all.map do |currency|
      {
        key: currency.id,
        label: currency.currency_code,
        symbol: currency.currency_sign,
        error_details: currency.error_details,
        reference_id: currency.reference_id,
        resolved: currency.resolved
      }
    end
    render json: currencies, status: :ok
  end
end
