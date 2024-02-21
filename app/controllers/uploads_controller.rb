class UploadsController < ApplicationController
  before_action :authenticate_request!

  def picture
    if @current_user&.document.attach(params[:document])
      render json: { message: 'Document uploaded successfully' }, status: :ok
    else
      render json: { error: 'Failed to upload document' }, status: :unprocessable_entity
    end

  end
end
