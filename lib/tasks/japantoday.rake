namespace :scrape do
  desc "Scrape news from JapanToday's website"
  task :japantoday => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://www.japantoday.com/feed",
      :regexes => [/(^.*japantoday.*$)/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end