class MessagesController < ApplicationController
  before_action :authenticate_request!

  before_action do
    @conversation = Conversation.find(params[:conversation_id])
  end

  def index
    @messages = @conversation.messages

    @messages.where("user_id != ? AND read = ?", @current_user.id, false).update_all(read: true)

    render json: { messages: @messages }, status: :ok
  end

  def create
    @message = @conversation.messages.new(message_params)
    @message.user = @current_user

    if @message.save
      render json: @message, status: :created, location: conversation_messages_path(@conversation)
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :user_id)
  end
end