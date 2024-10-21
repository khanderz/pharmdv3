class CountriesController < ApplicationController
    def index
        countries = Country.pluck(:country_name)
        render json: countries
    end
end
