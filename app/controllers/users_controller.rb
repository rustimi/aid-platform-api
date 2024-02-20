class UsersController < ApplicationController
  before_action :set_user, only: :show
  def index
    render json: {users: User.all}
  end

  def show
  end

  def create
    user = User.new(user_params)
    if user.save
      # Respond with appropriate message or token
      render json: { status: 'User created successfully', user_id: user.id}, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def update
  end

  def destroy
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
    def user_params
      params.permit(:fname, :lname, :email, :password, :password_confirmation)
    end
end
