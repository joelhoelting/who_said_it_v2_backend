class Api::V1::UsersController < ApplicationController
  include UsersHelper
  skip_before_action :authorized, :except => [:validate_token]

  def validate_token
    @user = current_user
    render :json => { :user => @user }, :status => :accepted
  end

  def password_reset
    if !verify_recaptcha('password_reset', recaptcha_params[:token])
      return render :json => { :error => 'Authentication Failure' }, :status => :unauthorized
    end

    @user = User.find_by(:email => user_credential_params[:email])

    if @user
      @user.generate_token_and_send_instructions(token_type: :password_reset)
      render :json => { :email => @user.email, :message => 'Check email for confirmation' }, :status => :created
    else
      render :json => { :error => 'There is no user with that email' }, :status => :not_found
    end
  end

  def signin
    # if !verify_recaptcha('signin', recaptcha_params[:token])
    #   return render :json => { :error => 'Authentication Failure' }, :status => :unauthorized
    # end

    @user = User.find_by(:email => user_credential_params[:email])

    # authenticate method comes from bcrypt
    if @user && @user.authenticate(user_credential_params[:password])
      if @user.email_confirmed
        @token = encode_token({ :user_id => @user.id })
        render :json => { :user => @user.parsed_user_data, :jwt => @token }, :status => :accepted
      else
        render :json => { :error => 'Please confirm your email address' }, :status => :forbidden
      end
    else
      render :json => { :error => 'Invalid credentials' }, :status => :unauthorized
    end
  end

  def signup
    # if !verify_recaptcha('signup', recaptcha_params[:token])
    #   return render :json => { :error => 'Account could not be created' }, :status => :unauthorized
    # end

    # Check if user with email already exists
    if User.find_by(:email => user_credential_params[:email])
      return render :json => { :error => 'User with that email address already exists' }, :status => :conflict
    end

    @user = User.new(user_credential_params)

    if @user.valid?
      @user.generate_token_and_send_instructions(token_type: :email_confirmation)
      render :json => { :email => @user.email, :message => 'Check email for confirmation' }, :status => :created
    else
      render :json => { :error => 'Failed to create user' }, :status => :not_acceptable
    end
  end

  def confirm_email
    @user = User.find_by(email_confirmation_token: params[:confirm_token])

    if !@user
      return render :json => { :error => 'Email confirmation link is not valid.', :redirect => '/signup' }, :status => :not_acceptable
    end

    if @user.email_confirmation_token && @user.token_expired?(:token_type => :email_confirmation)
      return render :json => { :error => 'Email confirmation link has expired. Please sign in again.', :redirect => '/signin' }, :status => :not_acceptable
    end
    
    @user.set_token_confirmed(:token_type => :email_confirmation)
    @user.update(:email_confirmed => true)

    @token = encode_token(:user_id => @user.id)

    render :json => { :user => @user.parsed_user_data, :jwt => @token }, :status => :ok
  end

  def resend_confirmation_email
    @user = User.find_by(email: user_credential_params[:email])

    if !@user
      return render :json => { :error => 'Cannot find a user with that email', :redirect => '/signup' }, :status => :not_acceptable
    else
      @user.generate_token_and_send_instructions(:token_type => :email_confirmation)
      render :json => { :email => @user.email, :message => 'Please check your email for new confirmation instructions' }, :status => :ok
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
