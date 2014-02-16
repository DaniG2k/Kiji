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
env  = 'RAILS_ENV=production'
all = "#{env} rake scrape:all"
zscore = "#{env} rake zscore"
clobber = "#{env} rake assets:clobber"
rmscreenshots = 'rm -f /home/dani/Kiji/app/assets/images/screenshots/*'
screenshots = "#{env} rake scrape:screenshots"
precompile = "#{env} rake assets:precompile"
nginx_recache = 'touch /home/dani/Kiji/tmp/restart.txt'


every :day, :at => '9:00 am' do
  command [all, zscore, clobber, rmscreenshots, screenshots, precompile, nginx_recache].join(' && ')
end