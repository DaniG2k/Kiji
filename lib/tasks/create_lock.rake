namespace :scrape do
  desc "Create lock on scrape task"
  task :create_lock => :environment do
    locker = Kiji::Locker.new
    locker.lock
  end
end