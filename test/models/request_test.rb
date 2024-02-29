require "test_helper"

class RequestTest < ActiveSupport::TestCase
  test 'should not save request without required fields' do
    request = Request.new
    assert_not request.save, 'Saved the request without a description, request_type, latitude, or longitude'
  end

  test 'should not save request with invalid request_type' do
    request = Request.new(description: 'Need help', request_type: 'Invalid type', latitude: 40.0, longitude: -74.0)
    assert_not request.save, 'Saved the request with an invalid request_type'
  end

end