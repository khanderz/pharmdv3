require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "should get searchPage" do
    get search_searchPage_url
    assert_response :success
  end
end
