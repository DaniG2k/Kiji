namespace :scrape do
  desc "Scrape news from CNN's website"
  task :cnn => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://rss.cnn.com/rss/edition_asia.rss",
      :regexes => [/(^.*cnn\.com((?!\/gallery\/|\/video\/).)*$)/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end