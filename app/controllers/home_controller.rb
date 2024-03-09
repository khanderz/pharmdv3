class HomeController < ApplicationController
  # maps to /app/views/layouts/home.html.erb
  layout "home" 
  
 # maps to /app/views/home/navbar.html.erb
  def navbar
    @navbar_props = { test: "test"}
  end
end
