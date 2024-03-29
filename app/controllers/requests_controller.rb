class RequestsController < ApplicationController
  before_action :authenticate_request!, only: [:index, :user_related, :create, :update, :show, :destroy, :republish, :fulfill]
  before_action :set_request, only: [:show, :update, :destroy, :republish, :fulfill]
  before_action :check_authorization, only: [:show, :update, :destroy, :republish, :fulfill]

  def index
    volunteer_request_ids = @current_user.volunteering_instances.select(:request_id).map(&:request_id)
    # all requests the user can volunteer
    requests = Request.where(fulfilled: false)
                      .where('fulfillment_count < 5')
                      .where.not(requester: @current_user)
                      .where.not(id: volunteer_request_ids)
                      .order(publish_date: :desc)

    if params[:ne_latitude] && params[:ne_longitude] && params[:sw_latitude] && params[:sw_longitude]
      requests = requests.in_bounds([[params[:sw_latitude].to_f, params[:sw_longitude].to_f],
                                    [params[:ne_latitude].to_f, params[:ne_longitude].to_f]]
                                    ).all
    end

    render json: { requests: requests }, status: :ok
  end
  def create
    # Initialize a new request with request parameters and assign the requester
    @request = Request.new(request_params)
    @request.requester = @current_user
    @request.publish_date = Time.current
    if @request.save
      # If the save succeeds, redirect or render as appropriate
      render json: @request, status: :created, location: requests_url(@request)
    else
      # If validations fail, return the errors
      render json: @request.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @request.update(request_params)
      render json: @request, status: :ok
    else
      render json: @request.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    render json: @request, status: :ok
  end

  def destroy
    if @request.destroy
      render json: { status: 'Request deleted successfully' }, status: :ok
    else
      render json: { errors: 'Failed to delete request' }, status: :unprocessable_entity
    end
  end

  def user_related
    #URL param rupublishable = [1|0]
    get_republishable = params[:republishable]

    # Select requests where the user is the requester
    requests_as_requester = Request.where(requester: @current_user).order(publish_date: :desc)

    if get_republishable == '1'
      # Get all the not fulfilled, older than 24h requests
      requests_as_requester_republishable = requests_as_requester.where(fulfilled: false).where('publish_date < ?', 24.hours.ago).order(publish_date: :desc)
      render json: {requests: requests_as_requester_republishable}, status: :ok
      return
    end
    # Select requests where the user is a volunteer through volunteering_instances
    requests_as_volunteer = Request.joins(:volunteering_instances).where(volunteering_instances: { user: @current_user }).where(fulfilled: false)
    user_requests_and_volunteerings = (requests_as_requester.where('publish_date > ?', 24.hours.ago).or(requests_as_requester.where(fulfilled: true)) + requests_as_volunteer).uniq
    render json: {requests: user_requests_and_volunteerings}, status: :ok
  end

  def republish
    if @request.update({publish_date: Time.current, fulfillment_count: 0})
      render json: @request, status: :ok
    else
      render json: @request.errors.full_messages, status: :unprocessable_entity
    end
  end

  def fulfill
    if @request.update({fulfilled: true})
      render json: @request, status: :ok
    else
      render json: @request.errors.full_messages, status: :unprocessable_entity
    end
  end

  def request_count
    requests_number = Request.where(fulfilled: false).where('fulfillment_count <= 5').count
    render json: { requests_number: requests_number }, status: :ok
  end

  private
  def check_authorization
    unless @current_user == @request.requester or @request.volunteers.exists?(@current_user.id)
      render json: { error: "Not authorized to access this request" }, status: :forbidden
    end
  end
  def request_params
    # Ensure you only allow the necessary parameters through
    params.require(:request).permit(:title, :description, :request_type, :latitude, :longitude)
  end
end
