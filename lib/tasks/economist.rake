namespace :scrape do
  
  feeds = %w(http://www.economist.com/rss/asia_rss.xml
             http://www.economist.com/rss/china_rss.xml
             http://www.economist.com/blogs/analects/index.xml)
             
  desc "Run all Economist scrape tasks"
  task :economist => :environment do
    feeds.each do |feed|
      worker = Kiji::Worker.new(
        :rss => feed,
        :regexes => [/(^.*economist\.com.*)\?.*$/])
      worker.fetch_rss_data
      worker.add_to_db
    end
  end
end