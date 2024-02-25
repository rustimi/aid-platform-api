require "test_helper"

class RequestTest < ActiveSupport::TestCase
  test 'should not save request without required fields' do
    request = Request.new
    assert_not request.save, 'Saved the request without a description, request_type, status, latitude, or longitude'
  end

  test 'should not save request with invalid request_type' do
    request = Request.new(description: 'Need help', request_type: 'Invalid type', status: 'unfulfilled', latitude: 40.0, longitude: -74.0)
    assert_not request.save, 'Saved the request with an invalid request_type'
  end

  test 'fulfillment_count triggers status change to unpublished' do
    requester = users(:one)
    request = Request.create(description: 'Test Request', request_type: 'One time task', status: 'unfulfilled', latitude: 40.0, longitude: -74.0, requester: requester, fulfillment_count: 4)
    request.update(fulfillment_count: 5)
    assert_equal 'unpublished', request.status, 'Status did not change to unpublished at fulfillment_count 5'
  end
end