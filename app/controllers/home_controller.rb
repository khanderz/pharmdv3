# frozen_string_literal: true

class HomeController < ApplicationController
  # maps to /app/views/layouts/application.html.erb
  layout 'application'

  def index
    render 'home/index'
  end

  def route_to_directory; end

  def route_to_pathfinder; end

  def route_to_admin_page; end
end
