class VolunteersController < ApplicationController
  before_action :authenticate_request!, only: :volunteer
  before_action :set_request, only: :volunteer
  before_action :check_authorization


  def volunteer
    @request.volunteering_instances.create(user: @current_user)
    @request.fulfillment_count += 1

    conversation = Conversation.between(@current_user.id, @request.requester_id, @request.id).first
    unless conversation
      conversation = Conversation.create(sender: @current_user, receiver: @request.requester, request: @request)
    end

    if @request.save
      render json: {conversation_id: conversation.id}, status: :ok
    else
      render json: @request.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  def check_authorization
    # A user can't volunteer to their own request
    if @current_user == @request.requester
      render json: { error: "Not authorized volunteer your requests!" }, status: :forbidden
    end
    if @request.volunteers.exists?(@current_user.id)
      render json: { error: "Cant apply multiple times for the same request!" }, status: :forbidden
    end
  end
end
