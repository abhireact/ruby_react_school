require "test_helper"

class UploadExcelControllerTest < ActionDispatch::IntegrationTest
  test "should get upload_file" do
    get upload_excel_upload_file_url
    assert_response :success
  end
end
