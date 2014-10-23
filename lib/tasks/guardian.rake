namespace :scrape do
  feeds = %w(http://feeds.theguardian.com/theguardian/world/china/rss
            http://www.theguardian.com/world/china+japan/rss
            http://www.theguardian.com/world/japan/rss
            http://www.theguardian.com/world/south-korea/rss
            http://www.theguardian.com/world/hong-kong/rss
            http://www.theguardian.com/world/taiwan/rss
            http://www.theguardian.com/world/mongolia/rss)
            
  desc "Run all Guardian scrape tasks"
  task :guardian => :environment do
    feeds.each do |feed|
      worker = Kiji::Worker.new(
        :rss => feed,
        :regexes => [/(^http.*)/])
      worker.fetch_rss_data
      worker.add_to_db
    end
  end
end
