class AuthenticationController < ApplicationController

  def login
    if request.headers['Authorization']
      render json: { success: "Already auth!" }, status: :ok
    else

      user = User.find_by_email(params[:email])

      if user&.authenticate(params[:password])
        token = encode_user_data({ user_id: user.id })
        response.set_header('Authorization', "Bearer #{token}")
        render json: { success: "Authenticated!" }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  end

  private

  def encode_user_data(payload)
    JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
  end
end
