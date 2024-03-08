class UsersController < ApplicationController
  before_action :authenticate_request!, only: [:show, :update, :destroy]

  def show
    # Load user attributes
    user_data = @current_user.slice('fname', 'lname', 'email')

    # Load document URL
    if @current_user.document.attached?
      # user_data[:document_url] = rails_blob_url(@current_user.document, disposition: "attachment", only_path: true)
      user_data[:document_url] = @current_user.document
    end
    render json: { user: user_data }, status: :ok
  end


  def create
    user = User.new(user_params)
    if user.save
      # Optionally attach document if included in the request
      user.document.attach(params[:document]) if params[:document].present?

      render json: { status: 'User created successfully', user: user.slice('id', 'fname', 'lname', 'email') }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end


  def update
    if @current_user.update(user_params)
      render json: { status: 'User updated successfully', user: @current_user.slice('id', 'fname', 'lname', 'email') }, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @current_user.destroy
      render json: { status: 'User deleted successfully' }, status: :ok
    else
      render json: { errors: 'Failed to delete user' }, status: :unprocessable_entity
    end
  end


  private
    def user_params
      params.permit(:fname, :lname, :email, :password, :document)
    end
end
