require 'test_helper'

class RakeMailerTest < ActionMailer::TestCase
  test "failed_rake_task" do
    mail = RakeMailer.failed_rake_task
    assert_equal "Failed rake task", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
