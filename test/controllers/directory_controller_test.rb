# frozen_string_literal: true

require 'test_helper'

class DirectoryControllerTest < ActionDispatch::IntegrationTest
  test 'should get directory' do
    get directory_directory_url
    assert_response :success
  end
end
