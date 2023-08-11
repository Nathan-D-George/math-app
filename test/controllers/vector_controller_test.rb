require "test_helper"

class VectorControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get vector_new_url
    assert_response :success
  end

  test "should get create" do
    get vector_create_url
    assert_response :success
  end

  test "should get destroy" do
    get vector_destroy_url
    assert_response :success
  end
end
