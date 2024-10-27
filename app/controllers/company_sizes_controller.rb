# frozen_string_literal: true

class CompanySizesController < ApplicationController
  def index
    company_sizes = CompanySize.all
    render json: company_sizes, status: :ok
  end
end
