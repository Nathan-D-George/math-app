require "test_helper"

class FunctionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get functions_new_url
    assert_response :success
  end

  test "should get create" do
    get functions_create_url
    assert_response :success
  end
end
