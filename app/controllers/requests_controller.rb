class RequestsController < ApplicationController
  before_action :authenticate_request!, only: [:user_requests_and_volunteerings, :create, :update, :show]
  before_action :check_authorization, only: [:update]

  def index
    if @current_user
      requests = Request.where.not(requester: @current_user.id)
    else
      requests = Request.all
    end
    render json: { requests: requests }, status: :ok
  end

  def user_requests_and_volunteerings
    # Select requests where the user is the requester
    requests_as_requester = Request.where(requester: @current_user)

    # Select requests where the user is a volunteer through volunteering_instances
    requests_as_volunteer = Request.joins(:volunteering_instances).where(volunteering_instances: { user: @current_user })

    user_requests_and_volunteerings = requests_as_requester + requests_as_volunteer
    render json: {requests: user_requests_and_volunteerings}, status: :ok
  end

  def create
    # Initialize a new request with request parameters and assign the requester
    request = Request.new(request_params)
    request.requester = @current_user

    if request.save
      # If the save succeeds, redirect or render as appropriate
      render json: request, status: :created, location: request
    else
      # If validations fail, return the errors
      render json: request.errors, status: :unprocessable_entity
    end
  end

  def update
    @request = Request.find(params[:id])
    if @request.update(request_params)
      render json: @request, status: :ok
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @request, status: :ok
  end



  private
  def set_request
    @request = Request.find_by(id: params[:id])
    unless @request
      render json: { error: "Request not found" }, status: :not_found
    end
  end
  def request_params
    # Ensure you only allow the necessary parameters through
    params.require(:request).permit(:description, :request_type, :status, :latitude, :longitude)
  end

  def check_authorization
    unless @current_user == @request.requester
      render json: { error: "Not authorized to update this request" }, status: :forbidden
    end
  end
end
