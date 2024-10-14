require "test_helper"

class WingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get wings_index_url
    assert_response :success
  end

  test "should get show" do
    get wings_show_url
    assert_response :success
  end

  test "should get create" do
    get wings_create_url
    assert_response :success
  end
end
