require "test_helper"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)

    #Renaming @request to @request_fixture to avoid the conflict with the internal @request variable
    @request_fixture = requests(:one)

    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
    @token = response.headers['Authorization']
  end

  test "should get index" do
    get requests_url
    assert_response :success
  end

  test "should create request" do
    # Simulate login to get a token (this step depends on your auth setup)
    put requests_url
    assert_difference('Request.count') do
      put requests_url, params: { request: { description: 'Help needed', request_type: 'One time task', latitude: 40.0, longitude: -74.0 } },
                        headers: { Authorization: @token }
    end

    assert_response :created
  end

  test "should show request" do
    get show_request_url(@request_fixture), headers: { Authorization: @token }
    assert_response :success
  end

  test "should update request" do
    patch update_request_url(@request_fixture), params: { request: { description: 'Updated help needed' } },
                                 headers: { Authorization: @token }
    assert_response :ok
  end

  test "should not update request without authorization" do
    # Assuming there's logic to simulate a different user who is not the requester
    patch update_request_url(@request_fixture), params: { request: { description: 'Unauthorized update' } }
    assert_response :unauthorized
  end
end
