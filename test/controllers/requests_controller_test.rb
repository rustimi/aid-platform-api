require 'test_helper'

class RequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john_doe)
    @request_groceries = requests(:groceries_request)
    # Log in the user
    post login_url, params: { email: @user.email, password: 'password' }
  end

  test "should get index" do
    get requests_url
    assert_response :success
  end

  test "should create request" do
    assert_difference('Request.count') do
      put requests_url, params: { request: { title: "This is title", description: 'Need a new task', request_type: 'One time task', latitude: 40.7128, longitude: -74.0060 } }, headers: { Authorization: @token }
    end
    assert_response :created
  end

  test "should show request" do
    get show_request_url(@request_groceries)
    assert_response :success
  end

  test "should update request" do
    patch update_request_url(@request_groceries), params: { request: { description: 'Updated description' } }
    assert_response :success
  end

  test "should destroy request" do
    assert_difference('Request.count', -1) do
      delete delete_request_url(@request_groceries)
    end
    assert_response :success
  end

  test "should get index with requests in bounds" do
    ne_lat, ne_lon = 40.8, -73.9 # North East corner of the bounding box
    sw_lat, sw_lon = 40.7, -74.1 # South West corner of the bounding box

    get requests_url, params: { ne_latitude: ne_lat, ne_longitude: ne_lon, sw_latitude: sw_lat, sw_longitude: sw_lon }
    assert_response :success
    requests = JSON.parse(@response.body)["requests"]

    requests.each do |request| lat = request["latitude"].to_f
    lon = request["longitude"].to_f
    assert lat.between?(sw_lat, ne_lat), "Latitude #{lat} out of bounds"
    assert lon.between?(sw_lon, ne_lon), "Longitude #{lon} out of bounds"
    end
  end

  test "user_related returns republishable requests when republishable is 1" do
    # Assuming republishable requests are not fulfilled and older than 24 hours
    get user_requests_url, params: { republishable: '1' }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_nil json_response["requests"]
    json_response["requests"].each do |request| assert_not request["fulfilled"]
    assert_operator Time.parse(request["publish_date"]), :<, 24.hours.ago
    end
  end

  test "user_related returns combined list of user requests and volunteered requests" do
    get user_requests_url
    assert_response :success
    json_response = JSON.parse(response.body)
    assert_not_nil json_response["requests"]

    groceries_request_id = requests(:groceries_request).id
    blanket_request_id = requests(:blanket_request).id

    response_ids = json_response["requests"].map { |r| r["id"] }
    assert_includes response_ids, blanket_request_id, "Expected response to include the blanket request ID"
    assert_not_includes response_ids, groceries_request_id, "Expected response to not include the groceries request ID"
  end
end
