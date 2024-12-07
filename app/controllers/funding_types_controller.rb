# frozen_string_literal: true

class FundingTypesController < ApplicationController
  def index
    funding_types = FundingType.all
    render json: funding_types, status: :ok
  end
end
