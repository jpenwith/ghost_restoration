require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get read" do
    get posts_read_url
    assert_response :success
  end
end
