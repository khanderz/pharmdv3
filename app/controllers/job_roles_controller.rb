class JobRolesController < ApplicationController
    def index
        job_roles = JobRole.pluck(:role_name)
        render json: job_roles
    end
end
