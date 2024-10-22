class DepartmentsController < ApplicationController
  def index
    @departments = Department.all
    render json: @departments
  end
end
