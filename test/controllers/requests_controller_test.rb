require "test_helper"

class RequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # Assuming you have a users fixture
    @request = requests(:one) # Assuming you have a requests fixture
    # Log in the user here if authentication is required
  end

  test "should get index" do
    get requests_url
    assert_response :success
  end

  test "should create request" do
    assert_difference('Request.count') do
      post requests_url, params: { request: { description: 'Help needed', request_type: 'One time task', status: 'unfulfilled', latitude: 40.0, longitude: -74.0, requester_id: @user.id } }
    end

    assert_response :created
  end

  test "should show request" do
    get request_url(@request)
    assert_response :success
  end

  test "should update request" do
    patch request_url(@request), params: { request: { description: 'Updated help needed' } }
    assert_response :ok
  end

  test "should not update request without authorization" do
    # Assuming there's logic to simulate a different user who is not the requester
    patch request_url(@request), params: { request: { description: 'Unauthorized update' } }
    assert_response :forbidden
  end
end
