class CompanySizeController < ApplicationController
    def index
      company_sizes = CompanySize.all
      render json: company_sizes, status: :ok
    end
  end
  