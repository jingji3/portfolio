class ApplicationMailer < ActionMailer::Base
  default from: Settings.mailer.sender_email
  layout 'mailer'
end
