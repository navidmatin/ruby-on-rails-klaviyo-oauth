require "test_helper"

class OAuthControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get o_auth_index_url
    assert_response :success
  end
end
