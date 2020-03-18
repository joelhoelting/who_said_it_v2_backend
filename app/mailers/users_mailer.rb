class UsersMailer < ApplicationMailer
  default :from => "no_reply@whosaidit.com"

  def email_confirmation
    @user = params[:user]
    @email_confirmation_url = "http://localhost:8080/confirm_email/#{@user.email_confirmation_token}"
    mail(:to => @user.email, :subject => "Registration Confirmation")
  end
end
