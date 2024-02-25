class RequestsController < ApplicationController
  before_action :authenticate_request!, only: [:user_requests_and_volunteerings]

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


  private
  def request_params
    # Ensure you only allow the necessary parameters through
    params.require(:request).permit(:description, :request_type, :status, :latitude, :longitude)
  end

end
