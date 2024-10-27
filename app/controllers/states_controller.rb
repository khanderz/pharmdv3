# frozen_string_literal: true

class StatesController < ApplicationController
  def index
    states = State.pluck(:state_name)
    render json: states
  end
end
