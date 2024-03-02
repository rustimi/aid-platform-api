require 'test_helper'

class ConversationTest < ActiveSupport::TestCase
  def setup
    @sender = users(:john_doe)
    @receiver = users(:jane_smith)
    @request = requests(:groceries_request)
    # Create a new conversation tied to @sender, @receiver, and @request
    @conversation = Conversation.new(sender_id: @sender.id, receiver_id: @receiver.id, request_id: @request.id)
  end

  test "should be valid" do
    assert @conversation.valid?
  end

  test "scope `between` should return the correct conversation" do
    @conversation.save
    conversations_between = Conversation.between(@sender.id, @receiver.id, @request.id)
    assert_equal 1, conversations_between.count
    assert_equal conversations_between.first, @conversation
  end

  test "sender id should be present" do
    @conversation.sender_id = nil
    assert_not @conversation.valid?
  end

  test "receiver id should be present" do
    @conversation.receiver_id = nil
    assert_not @conversation.valid?
  end

  test "request id should be present" do
    @conversation.request_id = nil
    assert_not @conversation.valid?
  end

  test "conversation should be unique" do
    duplicate_conversation = @conversation.dup
    @conversation.save
    assert_not duplicate_conversation.valid?
  end

  test "should not allow same sender and receiver" do
    @conversation.receiver_id = @conversation.sender_id
    assert_not @conversation.valid?
  end

end
