require 'test_helper'

class VolunteersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john_doe)
    @request_groceries = requests(:groceries_request)
    @request_ride = requests(:ride_request)
    # Assume john_doe is not the requester of groceries_request to allow volunteering
    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
  end

  test "should volunteer successfully" do
    assert_not_equal @user, @request_ride.requester

    assert_difference('@request_ride.volunteers.count') do
      post volunteer_url(@request_ride)
    end
    assert_response :ok
  end

  test "should not volunteer for own request" do
    # Check if the user is the requester of the request
    assert_equal @user, @request_groceries.requester

    assert_no_difference('@request_groceries.volunteers.count') do
      post volunteer_url(@request_groceries)
    end
    assert_response :forbidden
  end

  test "should not volunteer multiple times for the same request" do
    assert_not_equal @user, @request_ride.requester

    # Volunteer once successfully
    post volunteer_url(@request_ride)
    assert_response :ok

    # Try volunteering again for the same request
    assert_no_difference('@request_ride.volunteers.count') do
      post volunteer_url(@request_ride)
    end
    assert_response :forbidden
  end
end
