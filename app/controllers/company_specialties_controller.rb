# frozen_string_literal: true

class CompanySpecialtiesController < ApplicationController
  def index
    specialties = CompanySpecialty.select(:key, :value)
    render json: specialties.map { |specialty| { value: specialty.value, key: specialty.key } }
  rescue StandardError => e
    render json: { error: e.message }, status: 500
  end
end
