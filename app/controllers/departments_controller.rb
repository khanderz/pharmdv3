# frozen_string_literal: true

class DepartmentsController < ApplicationController
  def index
    @departments = Department.all
    render json: @departments
  end
end
