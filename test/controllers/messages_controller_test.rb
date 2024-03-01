require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @conversation = conversations(:one) # Assuming you have a conversation fixture

    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
    @token = response.headers['Authorization']
  end

  test "should get index" do
    get conversation_messages_url(@conversation), headers: { Authorization: @token }
    assert_response :success
  end

  test "should create message" do
    assert_difference('@conversation.messages.count') do
      post conversation_messages_url(@conversation), params: { message: { body: 'Hello there!', user_id: @user.id } }, headers: { Authorization: @token }
    end
    assert_response :created
  end
end
