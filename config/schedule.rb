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

set :output, {:error => File.join(Whenever.path, 'log', 'whenever_error.log'),
              :standard => File.join(Whenever.path, 'log', 'whenever_cron.log')}

env  = 'RAILS_ENV=production'
chdir = "cd #{Whenever.path}"
all = "#{env} rake scrape:all"
zscore = "#{env} rake zscore"
clobber = "#{env} rake assets:clobber"
screenshots = "#{env} rake scrape:screenshots"
precompile = "#{env} rake assets:precompile"
nginx_recache = 'touch /home/dani/Kiji/tmp/restart.txt'

every 6.hours do
  command [chdir, all, zscore, clobber, screenshots, precompile, nginx_recache].join(' && ')
end