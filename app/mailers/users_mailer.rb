class UsersMailer < ApplicationMailer
  default :from => "no_reply@whosaidit.com"

  def email_confirmation
    @user = params[:user]
    @email_confirmation_url = "http://localhost:8080/confirm_email/#{@user.email_confirmation_token}"
    mail(:to => @user.email, :subject => "Registration Confirmation")
  end

  def password_reset
    @user = params[:user]
    @password_reset_url = "http://localhost:8080/password_reset/#{@user.password_reset_token}"
    mail(:to => @user.email, :subject => "Reset Password")
  end
end
