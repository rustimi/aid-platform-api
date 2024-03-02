require 'test_helper'

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john_doe)
    @request_groceries = requests(:groceries_request)
    @conversation = conversations(:conversation_one)
    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
    @token = response.headers['Authorization']
  end

  test "should get all conversations of a request" do
    get request_conversations_url(@request_groceries), headers: { Authorization: @token }
    assert_response :success
  end
end
