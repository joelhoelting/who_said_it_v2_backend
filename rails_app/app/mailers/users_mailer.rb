class UsersMailer < ApplicationMailer
  def email_confirmation
    @user = params[:user]
    url = Rails.application.credentials[Rails.env.to_sym][:url]
    @email_confirmation_url = "#{url}/confirm_email/#{@user.email_confirmation_token}"
    mail(:to => @user.email, :subject => 'Registration Confirmation')
  end

  def password_reset
    @user = params[:user]
    url = Rails.application.credentials[Rails.env.to_sym][:url]
    @password_reset_url = "#{url}/password_reset/#{@user.password_reset_token}"
    mail(:to => @user.email, :subject => 'Reset Password')
  end
end
