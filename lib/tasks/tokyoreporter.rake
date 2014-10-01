namespace :scrape do
  desc "Scrape news from Tokyo Reporter's website"
  task :tokyoreporter => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://feeds.feedburner.com/TheTokyoReporter",
      :regexes => [/(^https?:\/\/www\.tokyoreporter\.com.*)/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end