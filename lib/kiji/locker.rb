#!/usr/bin/ruby
module Kiji
  class Locker
    def initialize
      @lock_file = "#{Rails.root}/lib/tasks/scrape.lock"
    end
    
    def lock
      if File.exist? @lock_file
        abort "There is currently a lock file present at #{@lock_file}\nThis means there is another scrape task in progress."
      else
        puts "Creating lock file..."
        File.open(@lock_file, 'a') {|f| f.write("Lock file last written: #{Time.zone.now}\n")}
      end
    end
    
    def unlock
      if File.exist?(@lock_file)
        puts "Removing lock file."
        File.delete(@lock_file)
      else
        puts "No lock file to remove."
      end      
    end
  end
end