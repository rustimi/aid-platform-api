require 'test_helper'

class VolunteeringInstanceTest < ActiveSupport::TestCase
  def setup
    @user = users(:john_doe) # Assuming your fixtures have a user named john_doe
    @request = requests(:groceries_request) # Assuming your fixtures have a request named groceries_request
    # Create a new volunteering instance tied to @user and @request
    @volunteering_instance = VolunteeringInstance.new(user_id: @user.id, request_id: @request.id)
  end

  test "should be valid" do
    assert @volunteering_instance.valid?
  end

  test "user id should be present" do
    @volunteering_instance.user_id = nil
    assert_not @volunteering_instance.valid?
  end

  test "request id should be present" do
    @volunteering_instance.request_id = nil
    assert_not @volunteering_instance.valid?
  end

  test "associated user should exist" do
    invalid_user_id = User.last.id + 1
    @volunteering_instance.user_id = invalid_user_id
    assert_not @volunteering_instance.valid?
  end

  test "associated request should exist" do
    invalid_request_id = Request.last.id + 1
    @volunteering_instance.request_id = invalid_request_id
    assert_not @volunteering_instance.valid?
  end
end
