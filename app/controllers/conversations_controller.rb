class ConversationsController < ApplicationController
  before_action :authenticate_request!
  before_action :set_request
  before_action :check_authorization

  def index
    if @current_user == @request.requester
      # The current user is the requester, so show all conversations for the request
      conversations = @request.conversations
    else
      # The current user is not the requester, so show only conversations involving the current user for this request
      # Since the conversation is always initialized by the volunteer, it's always the sender
      conversations = @request.conversations.where(sender: @current_user)
    end
    if conversations.empty?
      conversations_with_names = []
    else
      conversations_with_names = conversations.map do |conversation|
        {
          id: conversation.id,
          sender: {
            fname: conversation.sender.fname,
            lname: conversation.sender.lname
          },
          receiver: {
            fname: conversation.receiver.fname,
            lname: conversation.receiver.lname
          }
        }
      end
    end

    render json: conversations_with_names, status: :ok
  end



  private
  def check_authorization
    # Must be the requester or a volunteer
    if @current_user != @request.requester and !@request.volunteers.exists?(id: @current_user.id)
      render json: { error: "Not authorized see the conversations!" }, status: :forbidden
    end
  end
end
