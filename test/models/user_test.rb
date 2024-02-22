require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without required fields" do
    user = User.new
    assert_not user.save, "Saved the user without a first name, last name, or email"
  end

  test "should save user with all required fields and valid email" do
    user = User.new(fname: "John", lname: "Doe", email: "john.doe@example.com", password: "securepassword")
    assert user.save, "Couldn't save the user with all required fields"
  end

  test "should not save user with invalid email format" do
    user = User.new(fname: "John", lname: "Doe", email: "invalid-email", password: "securepassword")
    assert_not user.save, "Saved the user with an invalid email format"
  end

  test "email should be unique" do
    user1 = users(:one) # Assuming you have a users fixture
    user2 = User.new(fname: "Jane", lname: "Doe", email: user1.email, password: "securepassword")
    assert_not user2.save, "Saved two users with the same email"
  end

  test "should have one attached document" do
    user = users(:one) # Assuming you have a users fixture
    user.document.attach(io: File.open(Rails.root.join('test', 'fixtures', 'files', 'sample.jpg')), filename: 'sample.jpg', content_type: 'application/jpg')
    assert user.document.attached?, "User's document wasn't attached"
  end
end
