namespace :scrape do
  desc "Scrape news from Japan Daily Press' website"
  task :jdp => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://japandailypress.com/feed",
      :regexes => [/(^.*japandailypress.com.*)/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end