require "test_helper"

class UploadExcelSetOneControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get upload_excel_set_one_index_url
    assert_response :success
  end
end
