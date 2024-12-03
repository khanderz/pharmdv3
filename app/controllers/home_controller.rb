# frozen_string_literal: true

class HomeController < ApplicationController
  # maps to /app/views/layouts/application.html.erb
  layout 'application'

  def index
    render 'home/index'
  end
end
