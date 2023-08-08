require "test_helper"

class EquationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get equations_new_url
    assert_response :success
  end

  test "should get create" do
    get equations_create_url
    assert_response :success
  end

  test "should get destroy" do
    get equations_destroy_url
    assert_response :success
  end

  test "should get solve" do
    get equations_solve_url
    assert_response :success
  end
end
