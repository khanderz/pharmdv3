class SenioritiesController < ApplicationController
    def index
      @seniorities = JobSeniority.all
      render json: @seniorities
    end
end
