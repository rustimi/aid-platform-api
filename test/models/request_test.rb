require 'test_helper'

class RequestTest < ActiveSupport::TestCase
  def setup
    @user = users(:john_doe) # Assuming your fixtures have a user named john_doe
    # Create a new request tied to @user
    @request = @user.requests.build( title:"Example title", description: "Need help with groceries", request_type: "One time task", latitude: 40.7128, longitude: -74.0060)
  end

  test "should be valid" do
    assert @request.valid?
  end

  test "requester id should be present" do
    @request.requester_id = nil
    assert_not @request.valid?
  end

  test "description should be present" do
    @request.description = "   "
    assert_not @request.valid?
  end

  test "request type should be present" do
    @request.request_type = "   "
    assert_not @request.valid?
  end

  test "latitude should be present" do
    @request.latitude = nil
    assert_not @request.valid?
  end

  test "longitude should be present" do
    @request.longitude = nil
    assert_not @request.valid?
  end

  test "title should be present" do
    @request.title = nil
    assert_not @request.valid?
  end

  test "request type should be valid" do
    invalid_types = ["Unsupported type", "", nil]
    invalid_types.each do |invalid|
      @request.request_type = invalid
      assert_not @request.valid?, "#{invalid.inspect} should not be a valid request type"
    end
  end

  test "should have correct request types" do
    valid_types = ["One time task", "Material need"]
    valid_types.each do |valid|
      @request.request_type = valid
      assert @request.valid?, "#{valid.inspect} should be a valid request type"
    end
  end

  test "associated conversations should be destroyed" do
    @request.save
    @request.conversations.create!(sender_id: users(:jane_smith).id, receiver_id: @user.id)
    assert_difference 'Conversation.count', -1 do
      @request.destroy
    end
  end

  # Add more tests here for custom methods or additional validations
end
