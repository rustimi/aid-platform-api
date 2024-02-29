class ConversationsController < ApplicationController
  before_action :authenticate_request!

  def index
    conversations = Conversation.where("sender_id = ? OR receiver_id = ?", @current_user.id, @current_user.id)
    render json: { conversations: conversations }, status: :ok
  end

  def create
    if Conversation.between(params[:sender_id], params[:receiver_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:receiver_id]).first
      status= :ok
    else
      @conversation = Conversation.create!(conversation_params)
      status= :created
    end
    if @conversation.save
      render json: @conversation, status: status, location: conversation_messages_path(@conversation)
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  private
  def conversation_params
    params.permit(:sender_id, :receiver_id)
  end
end