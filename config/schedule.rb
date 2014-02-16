# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
every :day, :at => '9:00 am' do
  command 'rake scrape:all && rake zscore && rake assets:clobber && rm -f /home/dani/Kiji/app/assets/images/screenshots/* && rake scrape:screenshots && rake assets:precompile && touch /home/dani/Kiji/tmp/restart.txt'
end