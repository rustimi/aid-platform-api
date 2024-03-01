require 'test_helper'

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two) # Assuming you have another user fixture for conversations

    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
    @token = response.headers['Authorization']
  end

  test "should get index" do
    get conversations_url, headers: { Authorization: @token }
    assert_response :success
  end

  test "should not create conversation" do
    # test that if a conversation already exists, it do not create a new one
    assert_no_difference('Conversation.count') do
      post conversations_url, params: { sender_id: @user.id, receiver_id: @other_user.id }, headers: { Authorization: @token }
    end
    assert_response :ok
  end

  test "should create conversation" do
    # create a conversation if it's the first one
    third_user = users(:three)
    assert_difference('Conversation.count') do
      post conversations_url, params: { sender_id: @user.id, receiver_id: third_user.id }, headers: { Authorization: @token }
    end
    assert_response :created
  end
end
