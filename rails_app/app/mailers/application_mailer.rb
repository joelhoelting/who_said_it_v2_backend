class ApplicationMailer < ActionMailer::Base
  default :from => 'no-reply@whosaidit.co'
  layout 'mailer'
end
