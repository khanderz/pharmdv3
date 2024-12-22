# frozen_string_literal: true

class JobSalaryCurrenciesController < ApplicationController
  def index
    currencies = JobSalaryCurrency.all
    render json: currencies
  end
end
