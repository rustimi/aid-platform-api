require 'test_helper'

class VolunteersControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Assuming you have fixtures for users and requests
    @user = users(:one)
    @another_user = users(:two) # Another user to act as the requester
    @request_fixture = requests(:one)

    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
    @token = response.headers['Authorization']

    # Set the requester to another_user for the request
    @request_fixture.update(requester: @another_user)
  end

  test "should volunteer for a request successfully" do
    assert_difference('@request_fixture.volunteers.count') do
      post volunteer_url(@request_fixture), headers: { Authorization: @token }
    end
    assert_response :ok
    @request_fixture.reload
    assert_equal 1, @request_fixture.fulfillment_count
  end

  test "should not volunteer if not authenticated" do
    post volunteer_url(@request_fixture)
    assert_response :unauthorized # or :unauthorized, depending on how your authentication is setup
  end

  test "should not volunteer for own request" do
    # User tries to volunteer for their own request
    @request_fixture.update(requester: @user)
    post volunteer_url(@request_fixture), headers: { Authorization: @token }
    assert_response :forbidden
  end
end
