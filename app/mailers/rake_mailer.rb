class RakeMailer < ActionMailer::Base
  default from: "#{Rails.application.secrets.email['user']}@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.rake_mailer.failed_rake_task.subject
  #
  def failed_rake_task(args={})
    @method = args[:method]
    @rss = args[:rss]
    @curl = args[:curl]
    @error = args[:error]
    
    recipient = "#{Rails.application.secrets.email['user']}@gmail.com"
    
    mail to: recipient, subject: "Rake task failure"
  end
end
