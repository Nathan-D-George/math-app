require "test_helper"

class ConversionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get conversions_new_url
    assert_response :success
  end

  test "should get create_cylindrical" do
    get conversions_create_cylindrical_url
    assert_response :success
  end

  test "should get create_spherical" do
    get conversions_create_spherical_url
    assert_response :success
  end

  test "should get create_polar" do
    get conversions_create_polar_url
    assert_response :success
  end

  test "should get destroy" do
    get conversions_destroy_url
    assert_response :success
  end
end
