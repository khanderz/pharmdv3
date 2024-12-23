# frozen_string_literal: true

class CitiesController < ApplicationController
  def index
    cities = City.all
    render json: cities
  end
end
