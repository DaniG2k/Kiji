namespace :scrape do
  
  feeds = %w(http://online.wsj.com/xml/rss/3_7480.xml
             http://online.wsj.com/xml/rss/3_7441.xml
             http://online.wsj.com/xml/rss/3_8070.xml)
  
  desc "Run all WSJ scrape tasks"
  task :wsj => :environment do
    feeds.each do |feed|
      worker = Kiji::Worker.new(
        :rss => feed,
        :regexes => [/(^.*wsj\.com.*)\?/])
      worker.fetch_rss_data
      worker.add_to_db
    end
  end
end