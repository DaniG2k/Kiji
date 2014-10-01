namespace :scrape do
  desc "Clear lock on scrape task"
  task :clear_lock => :environment do
    file = "#{Rails.root}/lib/tasks/scrape.lock"
    puts "Removing lock file."
    File.delete(file) if File.exist?(file)
  end
end