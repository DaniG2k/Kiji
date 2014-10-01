namespace :scrape do
  desc "Scrape news from Nippon.com's website"
  task :nippon => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://www.nippon.com/en/feed/",
      :regexes => [/(^.*nippon\.com.*)/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end