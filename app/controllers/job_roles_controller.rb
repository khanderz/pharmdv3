# frozen_string_literal: true

class JobRolesController < ApplicationController
  def index
    job_roles = JobRole.all
    render json: job_roles
  end
end
