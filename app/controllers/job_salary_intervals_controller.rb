# app/controllers/job_salary_intervals_controller.rb
class JobSalaryIntervalsController < ApplicationController
  def index
    intervals = JobSalaryInterval.all.map do |interval|
      { id: interval.id, interval: interval.interval }
    end
    render json: intervals, status: :ok
  end
end
