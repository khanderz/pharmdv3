class DepartmentsController < ApplicationController
    def index
      departments = Department.pluck(:dept_name)
      render json: departments
    end
  end
  