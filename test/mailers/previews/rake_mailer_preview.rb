# Preview all emails at http://localhost:3000/rails/mailers/rake_mailer
class RakeMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/rake_mailer/failed_rake_task
  def failed_rake_task
    RakeMailer.failed_rake_task
  end

end
