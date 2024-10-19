require "test_helper"

class CbscExaminationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cbsc_examinations_index_url
    assert_response :success
  end
end
