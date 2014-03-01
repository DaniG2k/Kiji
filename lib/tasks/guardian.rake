namespace :scrape do

  feeds = %w(http://www.theguardian.com/world/china/rss
            http://www.theguardian.com/world/south-korea/rss
            http://www.theguardian.com/world/japan/rss
            http://www.theguardian.com/world/hong-kong/rss
            http://www.theguardian.com/world/taiwan/rss
            http://www.theguardian.com/world/mongolia/rss)
            
  desc "Run all Guardian scrape tasks"
  task :guardian_all => :environment do
    regexes = [/(^http.*)/]
    feeds.each do |feed| 
      add_to_db(fetch_rss_data(feed, regexes))
    end
  end
end