# frozen_string_literal: true

class SearchController < ApplicationController
  def search
    @search_props = { greeting: 'Welcome to the Search Page!' }

    render 'search/search'
  end
end
