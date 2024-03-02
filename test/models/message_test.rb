require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def setup
    @user = users(:john_doe) # Assuming your fixtures have a user named john_doe
    @conversation = conversations(:conversation_one) # Assuming your fixtures have a conversation named conversation_one
    # Create a new message tied to @user and @conversation
    @message = @conversation.messages.build(body: "Hello, can you help me?", user: @user)
  end

  test "should be valid" do
    assert @message.valid?
  end

  test "user id should be present" do
    @message.user_id = nil
    assert_not @message.valid?
  end

  test "conversation id should be present" do
    @message.conversation_id = nil
    assert_not @message.valid?
  end

  test "body should be present" do
    @message.body = "   "
    assert_not @message.valid?
  end

  # Test for a custom instance method
  test "message time format should be correct" do
    @message.save
    assert_equal @message.created_at.strftime("%d/%m/%y at %l:%M %p"), @message.message_time
  end
end
