require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(fname: 'Test', lname: 'User', email: 'test@example.com', password: 'PasswordTest123!', password_confirmation: 'PasswordTest123!')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "first name should be present" do
    @user.fname = "     "
    assert_not @user.valid?
  end

  test "last name should be present" do
    @user.lname = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "email addresses should be unique" do

    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "associated requests should be destroyed" do
    assert @user.save
    @user.requests.create!(title:"Title tst", description: "Lorem ipsum", request_type: "One time task", latitude: 0.0, longitude: 0.0)
    assert_equal 1, @user.requests.count, "Expected user to have one request"

    assert_difference 'Request.count', -1 do
      @user.destroy
    end
  end

end