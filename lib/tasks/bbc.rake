namespace :scrape do
  desc "Scrape news from BBC's website"
  task :bbc => :environment do
    regexes = [/(^http:\/\/.*bbc.*)#/]
    visited = fetch_rss_data("http://feeds.bbci.co.uk/news/world/asia/rss.xml", regexes)
    add_to_db(visited)
  end
end