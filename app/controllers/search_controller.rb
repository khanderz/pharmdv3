class SearchController < ApplicationController
  def searchPage
    @search_page_props = { some_data: 'data to pass to SearchPage component' }
    render "search/searchPage"
  end
end
