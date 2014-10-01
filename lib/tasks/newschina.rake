namespace :scrape do
  desc "Scrape news from NewsChina Magazine's website"
  task :newschina => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://www.newschinamag.com/rss/magazine_rss",
      :regexes => [/(^.*newschinamag.com.*$)/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end