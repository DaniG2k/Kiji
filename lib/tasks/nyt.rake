namespace :scrape do
  desc "Scrape news from New York Times' website"
  task :nyt => :environment do
    worker = Kiji::Worker.new(
      :rss => "http://www.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml",
      :regexes => [/(^.*\.htm)/, /(^.*world\/asia.*\.html)/, /(^.*)\?/])
    worker.fetch_rss_data
    worker.add_to_db
  end
end