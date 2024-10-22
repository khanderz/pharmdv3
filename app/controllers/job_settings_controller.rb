class JobSettingsController < ApplicationController
    def index
        @job_settings = JobSetting.all
        render json: @job_settings
    end
end
