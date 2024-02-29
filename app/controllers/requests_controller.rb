class RequestsController < ApplicationController
  before_action :authenticate_request!, only: [:user_related, :create, :update, :show, :destroy, :republish, :fulfill]
  before_action :set_request, only: [:update, :show, :destroy, :republish, :fulfill]
  before_action :check_authorization, only: [:update, :destroy, :republish, :fulfill]

  def index
    # all requests a user can volunteer
    requests = Request.where(fulfilled: false).where('fulfillment_count <= 5')

    if @current_user
      requests = requests.where.not(requester: @current_user)
    end

    render json: { requests: requests }, status: :ok
  end
  def create
    # Initialize a new request with request parameters and assign the requester
    @request = Request.new(request_params)
    @request.requester = @current_user
    if @request.save
      # If the save succeeds, redirect or render as appropriate
      render json: @request, status: :created, location: requests_url(@request)
    else
      # If validations fail, return the errors
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  def update
    if @request.update(request_params)
      render json: @request, status: :ok
    else
      render json: @request.errors, status: :unprocessable_entity
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
    #URL param rupublishable=1|0
    get_republishable = params[:republishable]

    # Select requests where the user is the requester
    requests_as_requester = Request.where(requester: @current_user)

    # Select requests where the user is a volunteer through volunteering_instances
    requests_as_volunteer = Request.joins(:volunteering_instances).where(volunteering_instances: { user: @current_user })

    user_requests_and_volunteerings = requests_as_requester + requests_as_volunteer

    if get_republishable
      # Get all the not fulfilled, older than 24h requests
      user_requests_and_volunteerings = user_requests_and_volunteerings.where(fulfilled: false, publish_date: 24.hours.ago..)
    end
    render json: {requests: user_requests_and_volunteerings}, status: :ok
  end

  def republish
    if @request.update({publish_date: Time.current, fulfillment_count: 0})
      render json: @request, status: :ok
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  def fulfill
    if @request.update({fulfilled: true})
      render json: @request, status: :ok
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end


  private
  def check_authorization
    unless @current_user == @request.requester
      render json: { error: "Not authorized to access this request" }, status: :forbidden
    end
  end
  def request_params
    # Ensure you only allow the necessary parameters through
    params.require(:request).permit(:description, :request_type, :latitude, :longitude)
  end
end
