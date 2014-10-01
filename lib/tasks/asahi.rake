namespace :scrape do
  desc "Scrape news from Asahi Shimbun's English website"
  task :asahi => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://ajw.asahi.com/feed/",
      :regexes => [/(^.*asahi\.com.*)/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end