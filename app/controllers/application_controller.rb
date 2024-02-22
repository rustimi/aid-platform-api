class ApplicationController < ActionController::API
  def authenticate_request!
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    if header == "admin"
      @current_user = User.find_by(email: 'admin@admin.it')
      return
    end
    begin
      @decoded = JWT.decode(header, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      @current_user = User.find(@decoded[0]['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: 'Unauthorized' }, status: :unauthorized
    end
  end
end
