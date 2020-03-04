class Api::V1::AuthController < ApplicationController
  include AuthHelper
  skip_before_action :authorized, :only => [:signup, :signin]

  def validate_token
    @user = current_user
    render :json => { :user => @user }, :status => :accepted
  end

  def signup
    if !verify_recaptcha('signup', recaptcha_params[:token])
      return render :json => { :error => 'Account could not be created' }, :status => :unauthorized
    end

    # Check if user with email already exists
    if User.find_by(:email => user_credential_params[:email])
      return render :json => { :error => 'User with email address already exists' }, :status => :conflict
    end

    @user = User.create(user_credential_params)

    if @user.valid?
      @token = encode_token(:user_id => @user.id)
      render :json => { :user => @user, :jwt => @token }, :status => :created
    else
      render :json => { :error => 'Failed to create user' }, :status => :not_acceptable
    end
  end

  def signin
    @user = User.find_by(:email => user_credential_params[:email])

    # authenticate method comes from bcrypt
    if @user && @user.authenticate(user_credential_params[:password])
      @token = encode_token({ :user_id => @user.id })
      render :json => { :user => @user, :jwt => @token }, :status => :accepted
    else
      render :json => { :error => 'Invalid credentials' }, :status => :unauthorized
    end
  end

  private

  def user_credential_params
    params.require(:auth).permit(:email, :password, :password_confirmation)
  end

  def recaptcha_params
    params.require(:recaptcha).permit(:token)
  end
end
