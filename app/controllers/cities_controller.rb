# frozen_string_literal: true

class CitiesController < ApplicationController
  def index
    cities = City.pluck(:city_name)
    render json: cities
  end
end
