class CompanySpecialtiesController < ApplicationController
  def index
    begin
      specialties = CompanySpecialty.select(:key, :value)
      render json: specialties.map { |specialty| { value: specialty.value, key: specialty.key } }
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end
end
