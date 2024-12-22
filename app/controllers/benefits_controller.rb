# frozen_string_literal: true

class BenefitsController < ApplicationController
  def index
    @benefits = Benefit.all
    render json: @benefits
  end
end
