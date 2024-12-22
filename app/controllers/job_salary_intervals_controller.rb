# frozen_string_literal: true

# app/controllers/job_salary_intervals_controller.rb
class JobSalaryIntervalsController < ApplicationController
  def index
    intervals = JobSalaryInterval.all
    render json: intervals
  end
end
