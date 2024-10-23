require "test_helper"

class ExamtypeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get examtype_index_url
    assert_response :success
  end
end
