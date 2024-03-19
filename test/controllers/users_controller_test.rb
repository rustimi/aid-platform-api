require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john_doe)
    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
  end

  test "should show user" do
    get users_url
    assert_response :success
    assert_equal @user.email, JSON.parse(response.body)['user']['email']
  end

  test "should create user" do
    assert_difference('User.count') do
      put users_url, params: {
        fname: 'New',
        lname: 'User',
        email: 'new.user@example.com',
        password: 'Password123!',
        document: fixture_file_upload('sample.jpg', 'image/jpg')
      }
    end
    assert_response :created
  end

  test "should update user" do
    patch users_url, params: {
      fname: 'Updated',
      lname: 'Name'
    }
    assert_response :success
    @user.reload
    assert_equal 'Updated', @user.fname
    assert_equal 'Name', @user.lname
  end

  test "should not update user with invalid email" do
    patch users_url, params: { email: 'invalidemail' }
    assert_response :unprocessable_entity
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete users_url
    end
    assert_response :success
  end
end
