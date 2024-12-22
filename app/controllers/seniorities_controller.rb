class SenioritiesController < ApplicationController
    def index
      @seniorities = Seniority.all
      render json: @seniorities
    end
end
