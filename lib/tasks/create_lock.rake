namespace :scrape do
  desc "Create lock on scrape task"
  task :create_lock => :environment do
    file = "#{Rails.root}/lib/tasks/scrape.lock"
    if File.exist? file
      abort("There is currently a lock file present at #{file}\nThis means there is another scrape task in progress.")
    else
      puts "Creating lock file..."
      File.open(file, 'a') {|f| f.write("Lock file last written: #{Time.zone.now}\n")}
    end
  end
end