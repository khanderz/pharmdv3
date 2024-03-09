require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get navbar" do
    get home_navbar_url
    assert_response :success
  end
end
