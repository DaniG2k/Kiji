namespace :scrape do
  desc "Scrape news from South China Morning Post's website"
  task :scmp => :environment do
    worker = Kiji::Worker.new(
      :rss => "www.scmp.com/rss/2/feed",
      :regexes => [/(^http:\/\/www\.scmp\.com.*)/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end