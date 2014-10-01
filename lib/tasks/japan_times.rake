namespace :scrape do
  desc "Scrape news from Japan Times' website"
  task :japantimes => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://feeds.feedburner.com/japantimes_news",
      :regexes => [/(^.*)\?/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end