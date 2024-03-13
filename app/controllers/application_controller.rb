include ActionController::Cookies
class ApplicationController < ActionController::API
  private
  def is_authenticated?
    begin
      jwt_token = cookies.signed[:jwt]
      @decoded = JWT.decode(jwt_token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      @current_user = User.find(@decoded[0]['user_id'])
      return true
    rescue
      return false
    end
  end
  def authenticate_request!
    unless is_authenticated?
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
