include ActionController::Cookies
class AuthenticationController < ApplicationController

  def login
    if params[:email].present? && params[:password].present?
      user = User.find_by_email(params[:email])

      if user&.authenticate(params[:password])
        token = encode_user_data({ user_id: user.id })
        cookies.signed[:jwt] = {
          value: token,
          httponly: true,
          expires: 48.hours.from_now,
          secure: Rails.env.production?, # Only send cookie over HTTPS in production
          same_site: Rails.env.production? ? :none : :strict
        }

        render json: { success: "Authenticated!" }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    else
      render json: { error: 'Missing email or password' }, status: :unauthorized
    end
  end

  def logout
    cookies.delete(:jwt, secure: Rails.env.production?, same_site: Rails.env.production? ? :none : :strict)
    render json: { success: "Logged out!" }, status: :ok
  end
  def check_session_status
    if is_authenticated?
      render json: { authenticated: true }, status: :ok
    else
      render json: { authenticated: false }, status: :ok
    end

  end
  private

  def encode_user_data(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end
end
