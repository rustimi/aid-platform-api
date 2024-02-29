class MessagesController < ApplicationController
  before_action :authenticate_request!
  before_action :set_request
  before_action :check_authorization
  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end


  def index
    @messages = @conversation.messages

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
    end
  end

  private
  def message_params
    params.require(:message).permit(:body)
  end

  def check_authorization
    # Must be the requester or a volunteer
    if @current_user != @request.requester and !@request.volunteers.exists?(@current_user.id)
      render json: { error: "Not authorized see the conversations!" }, status: :forbidden
    end

  end
end