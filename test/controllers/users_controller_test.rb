require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  test "should create user with valid parameters" do
    assert_difference('User.count', 1) do
      put users_path, params: { fname: "John", lname: "Doe", email: "john@example.com", password: "password", password_confirmation: "password" }
    end
    assert_response :created
  end

  test "should not create user with invalid parameters" do
    assert_no_difference('User.count') do
      put users_path, params: { fname: "", lname: "Doe", email: "john@example.com", password: "password", password_confirmation: "password" }
    end
    assert_response :bad_request
  end

end
