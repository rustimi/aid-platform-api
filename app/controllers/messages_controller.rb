class MessagesController < ApplicationController
  before_action :authenticate_request!
  before_action :set_request
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end
  before_action :check_authorization


  def index
    unless @conversation
      render json: { error: "Conversation not found" }, status: :not_found
      return
    end
    @messages = @conversation.messages.order(created_at: :asc)

    # set all messages as read since we are opening the all
    @messages.where("user_id != ? AND read = ?", @current_user.id, false).update_all(read: true)
    render json: { messages: @messages }, status: :ok
  end

  def create
    @message = @conversation.messages.new(message_params)
    @message.user = @current_user
    @message.conversation = @conversation

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  def message_params
    params.require(:message).permit(:body)
  end

  def check_authorization
    if @current_user != @request.requester and !@request.volunteers.exists?(@current_user.id)
      # Must be the requester or a volunteer
      render json: { error: "Not authorized access this conversation!" }, status: :forbidden
    elsif @conversation.request != @request
      # Check if the conversation belongs to the request
        render json: { error: "This conversation does not belong to the request!" }, status: :forbidden
    end

  end
end