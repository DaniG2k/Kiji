namespace :scrape do
  desc "Clear lock on scrape task"
  task :clear_lock => :environment do
    locker = Kiji::Locker.new
    locker.clear_lock
  end
end