require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john_doe)
    @request_groceries = requests(:groceries_request)
    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
    @token = response.headers['Authorization']
  end

  test "should get index" do
    get requests_url, headers: { Authorization: @token }
    assert_response :success
  end

  test "should create request" do
    assert_difference('Request.count') do
      put requests_url, params: { request: { description: 'Need a new task', request_type: 'One time task', latitude: 40.7128, longitude: -74.0060 } }, headers: { Authorization: @token }
    end
    assert_response :created
  end

  test "should show request" do
    get show_request_url(@request_groceries), headers: { Authorization: @token }
    assert_response :success
  end

  test "should update request" do
    patch update_request_url(@request_groceries), params: { request: { description: 'Updated description' } }, headers: { Authorization: @token }
    assert_response :success
  end

  test "should destroy request" do
    assert_difference('Request.count', -1) do
      delete delete_request_url(@request_groceries), headers: { Authorization: @token }
    end
    assert_response :success
  end
end
