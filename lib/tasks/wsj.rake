namespace :scrape do
  
  feeds = %w(http://online.wsj.com/xml/rss/3_7480.xml
             http://online.wsj.com/xml/rss/3_7441.xml
             http://online.wsj.com/xml/rss/3_8070.xml)
  
  desc "Run all WSJ scrape tasks"
  task :wsj => :environment do
    regexes = [/(^.*wsj\.com.*)\?/]
    feeds.each do |feed|
      add_to_db(fetch_rss_data(feed, regexes))
    end
  end
end