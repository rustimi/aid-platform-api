class VolunteersController < ApplicationController
  before_action :authenticate_request!, only: :volunteer
  before_action :set_request, only: :volunteer
  before_action :check_authorization, only: :volunteer


  def volunteer
    @request.volunteers.append(@current_user)
    @request.fulfillment_count += 1

    if @request.save
      render json: @request, status: :ok
    else
      render json: @request.errors, status: :unprocessable_entity
    end
  end

  private
  def check_authorization
    # A user can't volunteer to their own request
    if @current_user == @request.requester
      render json: { error: "Not authorized to access this request" }, status: :forbidden
    end
  end
end
