class ConversationsController < ApplicationController
  before_action :authenticate_request!
  before_action :set_request
  before_action :check_authorization

  def index
    if @current_user == @request.requester
      # The current user is the requester, so show all conversations for the request
      render json: @request.conversations, status: :ok
    else
      # The current user is not the requester, so show only conversations involving the current user for this request
      # Since the conversation is always initialized by the volunteer, it's always the sender
      conversation = @request.conversations.where(sender: @current_user)
      render json: conversation, status: :ok
    end
  end



  private
  def check_authorization
    # Must be the requester or a volunteer
    if @current_user != @request.requester and !@request.volunteers.exists?(@current_user.id)
      render json: { error: "Not authorized see the conversations!" }, status: :forbidden
    end
  end
end
