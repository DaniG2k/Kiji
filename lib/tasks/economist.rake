namespace :scrape do
  
  feeds = %w(http://www.economist.com/rss/asia_rss.xml
             http://www.economist.com/rss/china_rss.xml
             http://www.economist.com/blogs/analects/index.xml)
             
  desc "Run all Economist scrape tasks"
  task :economist => :environment do
    regexes = [/(^.*economist\.com.*)\?.*$/]
    feeds.each do |feed|
      add_to_db(fetch_rss_data(feed, regexes))
    end
  end
end