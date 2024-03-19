require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john_doe)
  end

  test "should set httponly cookie when login is successful" do
    post login_url, params: { email: @user.email, password: 'password' }
    assert_response :success
    assert_not_nil cookies['jwt']
    jwt_cookie = response.cookies['jwt']
    assert_not_nil jwt_cookie
  end

  test "should not authenticate with wrong password" do
    post login_url, params: { email: @user.email, password: 'wrongpassword' }
    assert_response :unauthorized
  end
end
