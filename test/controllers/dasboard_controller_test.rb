require "test_helper"

class DasboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dasboard_index_url
    assert_response :success
  end
end
