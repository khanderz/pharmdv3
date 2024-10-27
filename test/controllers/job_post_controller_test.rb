# frozen_string_literal: true

class JobRolesController < ApplicationController
  def index
    job_roles = JobRole.includes(:departments, :teams).all

    render json: job_roles.as_json(include: {
                                     departments: { only: :dept_name },
                                     teams: { only: :team_name }
                                   }, only: %i[role_name aliases])
  end
end
