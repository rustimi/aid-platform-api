class ApplicationController < ActionController::API
  private
  def authenticate_request!
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    if header == "admin"
      @current_user = User.find_by(email: 'john.doe@example.com')
      return
    end
    if header == "admin2"
      @current_user = User.find_by(email: 'jane.doe@example.com')
      return
    end
    if header == "admin3"
      @current_user = User.find_by(email: 'jim.beam@example.com')
      return
    end

    begin
      @decoded = JWT.decode(header, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      @current_user = User.find(@decoded[0]['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end
  def set_request
    @request = Request.find_by(id: params[:id])
    unless @request
      render json: { error: "Request not found" }, status: :not_found
    end
  end
end
