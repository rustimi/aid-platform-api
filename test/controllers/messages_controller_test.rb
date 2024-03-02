require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john_doe)
    @groceries_request = requests(:groceries_request)
    @conversation = conversations(:conversation_two)
    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
    @token = response.headers['Authorization']
  end

  test "should get index" do
    get conversation_messages_url(@groceries_request, @conversation), headers: { Authorization: @token }
    assert_response :success
    messages = JSON.parse(response.body)
    assert_not_empty messages
  end

  test "should create message" do
    assert_difference('@conversation.messages.count') do
      put new_conversation_message_url(@groceries_request, @conversation),
           params: { message: { body: 'A new message' } },
           headers: { Authorization: @token }
    end
    assert_response :created
    assert_equal 'A new message', JSON.parse(response.body)['body']
  end

  test "should not create message with empty body" do
    assert_no_difference('@conversation.messages.count') do
      put new_conversation_message_url(@groceries_request, @conversation),
           params: { message: { body: '' } },
           headers: { Authorization: @token }
    end
    assert_response :unprocessable_entity
  end

  test "should not create message if not authorized" do
    # Log in a different user who is not authorized
    unauthorized_user = users(:frank_west)
    post login_url, params: { email: unauthorized_user.email, password: 'password' }
    token = response.headers['Authorization']

    # Ensure the unauthorized user is not the sender or receiver of the conversation
    assert_not_equal @conversation.sender,  unauthorized_user
    assert_not_equal @conversation.receiver,  unauthorized_user
    assert_not_equal @conversation.request.requester,  unauthorized_user
    assert_not @conversation.request.volunteers.exists?(unauthorized_user.id)

    assert_no_difference('@conversation.messages.count') do
      put new_conversation_message_url(@conversation.request, @conversation),
           params: { message: { body: 'A new message' } },
           headers: { Authorization: token }
    end
    assert_response :forbidden
  end
end
