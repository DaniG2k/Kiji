namespace :scrape do
  desc "Scrape news from BBC's website"
  task :bbc => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://feeds.bbci.co.uk/news/world/asia/rss.xml",
      :regexes => [/(^http:\/\/.*bbc.*)[^#]/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end