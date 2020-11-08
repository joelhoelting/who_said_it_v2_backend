# .authenticate method comes from bcrypt

class Api::V1::UsersController < ApplicationController
  include UsersHelper
  skip_before_action :authorized, :except => [:delete_account, :update_password, :validate_token]

  def validate_token
    @user = current_user
    @token = encode_token({ :user_id => @user.id })
    render :json => { :jwt => @token, :success_msg => 'Valid login token', :user => @user.parsed_user_data }, :status => :accepted
  end

  def request_password_reset
    if !verify_recaptcha('request_password_reset', recaptcha_params[:token])
      return render :json => { :error_msg => 'Authentication Failure' }, :status => :unauthorized
    end

    @user = User.find_by(:email => user_credential_params[:email])

    if @user
      @user.generate_token_and_send_instructions(:token_type => :password_reset)
      render :json => { :email => @user.email, :success_msg => 'Check email for password reset instructions' }, :status => :created
    else
      render :json => { :error_msg => 'There is no user with that email' }, :status => :not_found
    end
  end

  def confirm_password_reset_token
    @user = User.find_by(password_reset_token: params[:password_reset_token])

    if @user && @user.awaiting_confirmation?(:token_type => :password_reset)
      render :json => { :success_msg => 'Password reset link is valid' }, :status => :ok
    else
      render :json => { :error_msg => 'Password reset link is invalid' }, :status => :not_found
    end
  end

  def reset_password
    if !verify_recaptcha('reset_password', recaptcha_params[:token])
      return render :json => { :error_msg => 'Authentication Failure' }, :status => :unauthorized
    end

    @user = User.find_by(password_reset_token: user_credential_params[:password_reset_token])

    if @user && @user.token_expired?(:token_type => :password_reset, :expiration => 10.minutes)
      return render :json => { :error_msg => 'Password reset link has expired. Please request a new one.'}, :status => :not_acceptable
    elsif @user
      @user.set_token_confirmed(:token_type => :password_reset)
      @user.update(:password => user_credential_params[:password])
      render :json => { :success_msg => 'Password has been updated'}
    else
      render :json => { :error_msg => 'This resource is not authorized' }, :status => :unauthorized
    end
  end

  def update_password
    @user = current_user

    if @user == @user.authenticate(user_credential_params[:original_password])
      new_password = user_credential_params[:password]
      password = user_credential_params[:password_confirmation]

      if passwords_match?(new_password, password)
        @user.update(:password => new_password)
        render :json => { :success_msg => 'Password has been updated' }, :status => :ok
      else
        render :json => { :error_msg => 'Passwords do not match'}, :status => :unauthorized
      end
    else
      render :json => { :error_msg => 'Original password is incorrect'}, :status => :not_found
    end
    
  end

  def sign_in
    if !verify_recaptcha('sign_in', recaptcha_params[:token])
      return render :json => { :error_msg => 'Authentication Failure' }, :status => :unauthorized
    end

    @user = User.find_by(:email => user_credential_params[:email])

    if @user && @user.authenticate(user_credential_params[:password])
      if @user.email_confirmed
        @token = encode_token({ :user_id => @user.id })
        render :json => { :jwt => @token, :success_msg => 'Sign in successful', :user => @user.parsed_user_data }, :status => :accepted
      else
        render :json => { :error_msg => 'Please confirm your email address' }, :status => :forbidden
      end
    else
      render :json => { :error_msg => 'Invalid credentials' }, :status => :unauthorized
    end
  end

  def sign_up
    if !verify_recaptcha('sign_up', recaptcha_params[:token])
      return render :json => { :error_msg => 'Account could not be created' }, :status => :unauthorized
    end

    # Check if user with email already exists
    if User.find_by(:email => user_credential_params[:email])
      return render :json => { :error_msg => 'User with that email address already exists' }, :status => :conflict
    end

    @user = User.new(user_credential_params)

    if @user.valid?
      @user.generate_token_and_send_instructions(token_type: :email_confirmation)
      render :json => { 
        :success_msg => "Confirmation email sent to #{@user.email}", 
        :email => @user.email, :success_msg => "Confirmation email sent to #{@user.email}" 
      }, :status => :created
    else
      render :json => { :error_msg => 'Failed to create user' }, :status => :not_acceptable
    end
  end

  def confirm_email
    @user = User.find_by(email_confirmation_token: params[:confirm_token])

    if !@user
      return render :json => { :error_msg => 'Email confirmation link is not valid.', :redirect => '/signup' }, :status => :not_acceptable
    end

    if @user.email_confirmation_token && @user.token_expired?(:token_type => :email_confirmation, :expiration => 1.hour)
      return render :json => { :error_msg => 'Email confirmation link has expired. Please sign in again.', :redirect => '/signin' }, :status => :not_acceptable
    end
    
    @user.set_token_confirmed(:token_type => :email_confirmation)
    @user.update(:email_confirmed => true)

    @token = encode_token(:user_id => @user.id)

    render :json => { :jwt => @token, :success_msg => 'Your account has been successfully created.', :user => @user.parsed_user_data }, :status => :ok
  end

  def resend_confirmation_email
    @user = User.find_by(email: user_credential_params[:email])

    if !@user
      return render :json => { :error_msg => 'Cannot find a user with that email' }, :status => :not_acceptable
    else
      @user.generate_token_and_send_instructions(:token_type => :email_confirmation)
      render :json => { :email => @user.email, :success_msg => 'Please check your email for new confirmation instructions' }, :status => :ok
    end
  end

  def delete_account
    @user = current_user

    if @user.games.delete_all && @user.delete
      return render :json => { :success_msg => 'Account successfully deleted' }, :status => :ok
    else
      return render :json => { :error_msg => 'There was an issue deleting account. Please try again.' }, :status => :bad_request
    end
  end

  private

  def user_credential_params
    params.require(:auth).permit(:email, :original_password, :password, :password_confirmation, :password_reset_token)
  end

  def recaptcha_params
    params.require(:recaptcha).permit(:token)
  end
end
