class ContactMailer < ActionMailer::Base
  default from: Rails.application.secrets.email['full_email']

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.rake_mailer.failed_rake_task.subject
  #
  def contact_form(args={})
    @name = args[:name]
    @email = args[:email]
    @message = args[:message]
    
    recipient = Rails.application.secrets.email['full_email']
    
    mail(to: recipient, subject: "#{t('title')} contact form")
  end
end
