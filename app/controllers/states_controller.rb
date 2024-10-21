class StatesController < ApplicationController
    def index
        states = State.pluck(:state_name)
        render json: states
    end
end
