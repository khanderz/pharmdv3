class TeamsController < ApplicationController
    def index
        teams = Team.pluck(:team_name)
        render json: teams
    end
end
