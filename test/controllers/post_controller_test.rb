require "test_helper"

class PostControllerTest < ActionDispatch::IntegrationTest
  test "should get read" do
    get post_read_url
    assert_response :success
  end
end
