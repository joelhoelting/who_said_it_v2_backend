class Api::V1::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def profile
    @user = current_user
    render json: { user: @user }, status: :accepted
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      @token = encode_token(user_id: @user.id)
      render json: { user: @user, jwt: @token }, status: :created
    else
      render json: { error: 'Failed to create user' }, status: :not_acceptable
    end
  end

  private

  def user_params
    params.permit(:email, :password)
  end
end